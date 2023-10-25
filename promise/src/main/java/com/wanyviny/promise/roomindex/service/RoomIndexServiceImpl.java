//package com.wanyviny.promise.roomindex.service;
//
//import com.wanyviny.promise.roomindex.domain.RoomIndex;
//import com.wanyviny.promise.roomindex.domain.dto.RoomIndexDto;
//import com.wanyviny.promise.roomindex.repository.RoomIndexRepository;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;
//
//@Service
//@Slf4j
//@RequiredArgsConstructor
//@Transactional(readOnly = true)
//public class RoomIndexServiceImpl implements RoomIndexService {
//
//    private final RoomIndexRepository roomIndexRepository;
//
//    private static final String ID = "6535e81131a96c027bfc040d";
//
//    @Override
//    public RoomIndexDto findRoomIndex() {
//        RoomIndex roomIndex =
//                roomIndexRepository.findById(ID).orElseThrow();
//
//        return RoomIndexDto.builder().index(roomIndex.getIndex()).build();
//    }
//
//    @Transactional
//    @Override
//    public RoomIndexDto increaseRoomIndex() {
//        RoomIndex roomIndex =
//                roomIndexRepository.findById(ID).orElseThrow();
//
//        roomIndex.increaseIndex();
//        roomIndexRepository.save(roomIndex);
//
//        return RoomIndexDto.builder().index(roomIndex.getIndex()).build();
//    }
//}