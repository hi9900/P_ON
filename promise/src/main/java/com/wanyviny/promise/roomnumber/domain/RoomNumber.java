package com.wanyviny.promise.roomnumber.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "room_number")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoomNumber {

    @Id
    private String id;
    private Long roomNumber;
}