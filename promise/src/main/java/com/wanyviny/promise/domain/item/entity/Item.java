package com.wanyviny.promise.domain.item.entity;

import com.wanyviny.promise.domain.room.entity.Room;
import com.wanyviny.promise.domain.user.entity.User;
import com.wanyviny.promise.domain.vote.dto.VoteDto;
import com.wanyviny.promise.domain.vote.entity.Vote;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.util.List;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@ToString
@Entity
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "ITEM")
public class Item {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ITEM_ID")
    private Long id;

    @Column(name = "ITEM_TYPE")
    @Enumerated(EnumType.STRING)
    private ItemType itemType;

    private String date;
    private String time;
    private String location;
    private String lat;
    private String lng;

    @ManyToOne
    @JoinColumn(name = "ROOM_ID")
    private Room room;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "item")
    private List<Vote> votes;

    public VoteDto.get.getDate entityToDate(){
        return VoteDto.get.getDate.builder()
                .itemId(this.id)
                .date(this.date)
                .users(this.votes.stream().map(Vote::getUser)
                        .map(User::entityToDto)
                        .toList())
                .build();
    }

    public VoteDto.get.getTime entityToTime(){
        return VoteDto.get.getTime.builder()
                .itemId(this.id)
                .time(this.time)
                .users(this.votes.stream().map(Vote::getUser)
                        .map(User::entityToDto)
                        .toList())
                .build();
    }

    public VoteDto.get.getLocation entityToLocation(){
        return VoteDto.get.getLocation.builder()
                .itemId(this.id)
                .location(this.location)
                .lat(this.lat)
                .lng(this.lng)
                .users(this.votes.stream().map(Vote::getUser)
                        .map(User::entityToDto)
                        .toList())
                .build();
    }
}
