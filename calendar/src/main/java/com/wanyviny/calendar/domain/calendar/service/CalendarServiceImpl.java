package com.wanyviny.calendar.domain.calendar.service;

import com.wanyviny.calendar.domain.PRIVACY;
import com.wanyviny.calendar.domain.calendar.dto.CalendarDto;
import com.wanyviny.calendar.domain.calendar.entity.Calendar;
import com.wanyviny.calendar.domain.calendar.repository.CalendarRepository;
import com.wanyviny.calendar.domain.follow.repository.FollowRepository;
import com.wanyviny.calendar.domain.user.entity.User;
import com.wanyviny.calendar.domain.user.repository.UserRepository;
import com.wanyviny.calendar.global.kafka.service.KafkaProducerService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@RequiredArgsConstructor
public class CalendarServiceImpl implements CalendarService {

    private final CalendarRepository calendarRepository;
    private final UserRepository userRepository;
    private final FollowRepository followRepository;
    private final KafkaProducerService producerService;


    @Override
    @Transactional
    public void postSchedule(Long id, CalendarDto.setSchedule schedule) {
        User user = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("ID에 해당하는 유저가 없습니다.")
        );
        Calendar calendar = calendarRepository.save(schedule.dtoToEntity(user));
        producerService.sendCalendar(calendar.entityToKafka());
    }


    @Override
    public List<CalendarDto.getSchedule> getMySchedule(Long id) {
        List<Calendar> calendarList = calendarRepository.findByUserId_id(id);

        return calendarList.stream()
                .map(Calendar::entityToDto)
                .toList();

    }

    @Override
    public CalendarDto.getSchedule getDetailSchedule(Long id, Long calendarId) {
        Calendar calendar = calendarRepository.findById(calendarId).orElseThrow(
                () -> new IllegalArgumentException("해당 일정이 없습니다.")
        );

        return calendar.entityToDto();

    }

    @Override
    public List<CalendarDto.promiseScheduleDto> getUserSchedule(Long id, Long userId) {

        // user의 privacy를 먼저 보고
        PRIVACY privacy = userRepository.findPrivacyById(userId);

        if (privacy == PRIVACY.PRIVATE) { // private일 경우 null
            return null;
        } else if (privacy == PRIVACY.FOLLOWING) { // following 일 경우 following 여부를 파악 후 일정 가져옴
            if (followRepository.existsFollowByUserId_IdAndFollowingId_Id(userId, id)) {
                List<Calendar> calendarList = calendarRepository.findByUserId_id(userId);
                return calendarList.stream()
                        .map(Calendar::entityToPromiseDto)
                        .toList();
            } else {
                return null;
            }
        } else { // all 일경우 그냥 가져옴
            List<Calendar> calendarList = calendarRepository.findByUserId_id(userId);

            return calendarList.stream()
                    .map(Calendar::entityToPromiseDto)
                    .toList();
        }

    }

    @Override
    @Transactional
    // TODO : null 값은 변경하지 않도록 수정 -> null로 변경하고 싶은 값은 어떻게 할까? content 지운다거나
    public void updateSchedule(Long id, Long calendarId, CalendarDto.setSchedule schedule) {
        Calendar calendar = calendarRepository.findByUserId_idAndId(id, calendarId).orElseThrow(
                () -> new IllegalArgumentException("해당하는 일정이 없습니다.")
        );
        calendar.update(schedule);
        calendarRepository.save(calendar);
        producerService.sendCalendar(calendar.entityToKafka());
    }

    @Override
    @Transactional
    public void deleteSchedule(Long id, Long calendarId) {
        calendarRepository.deleteByUserId_IdAndId(id, calendarId);
    }

    @Override
    public void deleteScheduleList(Long id, List<Long> deleteList) {
        calendarRepository.deleteByUserId_IdAndIdList(id, deleteList);
    }

    @Override
    public Map<String, List<CalendarDto.promiseScheduleDto>> getPromiseSchedule(List<Long> userIdList) {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(java.util.Calendar.MONTH, 6);

        Map<String, List<CalendarDto.promiseScheduleDto>> map = new HashMap<>();

        for (Long id : userIdList
        ) {
            List<Calendar> calendarList = calendarRepository.findByUserId_Id(id);
            map.put(String.valueOf(id), calendarList.stream()
                    .filter(calendar -> !(calendar.getEndDate().before(new Date()) || calendar.getStartDate().after(cal.getTime())))
                    .map(Calendar::entityToPromiseDto)
                    .toList());
        }

        return map;
    }


}
