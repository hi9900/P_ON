package com.wanyviny.user.domain.user.controller;

import com.wanyviny.user.domain.common.BasicResponse;
import com.wanyviny.user.domain.user.dto.KakaoUserDto;
import com.wanyviny.user.domain.user.dto.UserDto;
import com.wanyviny.user.domain.user.dto.UserSignUpDto;
import com.wanyviny.user.domain.user.entity.User;
import com.wanyviny.user.domain.user.service.UserService;
import com.wanyviny.user.global.jwt.service.JwtService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
@Tag(name = "유저", description = "유저 API")
public class UserController {

    private final UserService userService;
    private final JwtService jwtService;

    @PostMapping("/kakao-login")
    @Operation(summary = "카카오 로그인", description = "카카오 토큰과 phoneId를 받아 가입 or 로그인합니다.")
    public ResponseEntity<BasicResponse> kakaoLogin(@RequestHeader("Authorization") String authorization,
                                                    @RequestBody Map<String, String> phoneId) throws Exception {
        String accessToken = authorization.replace("Bearer ", "");
        Map<String, String> tokenMap = userService.kakaoLogin(accessToken, phoneId.get("phoneId"));
        HttpHeaders headers = new HttpHeaders();
        if (tokenMap.get("ROLE").equals("GUEST")) {
            headers.add("Authorization", tokenMap.get("Authorization"));
            headers.add("id", tokenMap.get("id"));
            headers.add("ROLE", tokenMap.get("ROLE"));
        } else {
            headers.add("Authorization", tokenMap.get("Authorization"));
            headers.add("Authorization_refresh", tokenMap.get("Authorization_refresh"));
            headers.add("id", tokenMap.get("id"));
            headers.add("ROLE", tokenMap.get("ROLE"));
        }

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("카카오에서 받은 유저 로그인 성공")
                .build();

        return new ResponseEntity<>(basicResponse, headers, basicResponse.getHttpStatus());
    }

    @GetMapping("/kakao-profile")
    @Operation(summary = "카카오 로그인 후 사용자 정보", description = "카카오 로그인한 GUEST의 정보를 가져옵니다.(회원가입시)")
    public ResponseEntity<BasicResponse> getKakaoProfile(@RequestHeader("id") Long id) {

        User userProfile = userService.getUserProfile(id);

        KakaoUserDto kakaoUserDto = KakaoUserDto.builder()
                .profileImage(userProfile.getProfileImage())
                .nickName(userProfile.getNickname())
                .privacy(userProfile.getPrivacy())
                .build();

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("카카오에서 받은 유저 정보 조회 성공")
                .count(1)
                .result(Collections.singletonList(kakaoUserDto))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PostMapping("/sign-up")
    @Operation(summary = "회원가입", description = "사용자를 회원가입시켜 USER로 만들어 줍니다.")
    public ResponseEntity<BasicResponse> signup(@RequestHeader("Authorization") String authorization,
                                                @RequestHeader("id") Long id,
                                                @RequestBody UserSignUpDto userSignUpDto) {
        String accessToken = authorization.replace("Bearer ", "");

        userService.signUp(userSignUpDto, id);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("회원 가입 성공!")
                .build();

        String refreshToken = jwtService.createRefreshToken();

        // 헤더에 토큰 정보 추가
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        headers.add("Authorization_refresh", "Bearer " + refreshToken);

        jwtService.updateRefreshToken(id, refreshToken);

        return new ResponseEntity<>(basicResponse, headers, basicResponse.getHttpStatus());
    }

    @GetMapping("/profile")
    @Operation(summary = "사용자 정보 조회", description = "사용자의 정보를 조회합니다.")
    public ResponseEntity<BasicResponse> getProfile(@RequestHeader("id") Long id) {

        User userProfile = userService.getUserProfile(id);

        UserDto userDto = UserDto.builder()
                .id(userProfile.getId())
                .profileImage(userProfile.getProfileImage())
                .nickName(userProfile.getNickname())
                .privacy(userProfile.getPrivacy())
                .stateMessage(userProfile.getStateMessage())
                .build();

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("유저 정보 조회 성공")
                .count(1)
                .result(Collections.singletonList(userDto))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PutMapping("/update")
    @Operation(summary = "사용자 정보 수정", description = "사용자의 정보를 수정합니다.")
    public ResponseEntity<BasicResponse> userUpdate(@RequestHeader("id") Long id, @RequestBody UserDto userDto) {

        userService.update(userDto, id);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("유저 정보 수정 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/logout")
    @Operation(summary = "카카오 로그아웃", description = "사용자가 카카오 로그아웃합니다.")
    public ResponseEntity<BasicResponse> logout(@RequestHeader("id") Long id) throws Exception {

        userService.logout(id);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("유저 로그아웃 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @DeleteMapping("/withdrawal")
    @Operation(summary = "회원 탈퇴", description = "카카오에서 연결을 끊고 회원을 탈퇴합니다.")
    public ResponseEntity<BasicResponse> withdrawal(@RequestHeader("id") Long id) throws Exception {

        userService.withdrawal(id);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("회원 탈퇴 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/search/{keyword}")
    @Operation(summary = "유저 검색", description = "사용자를 검색합니다.")
    public ResponseEntity<BasicResponse> searchUser(@RequestHeader("id") Long id, @PathVariable(name = "keyword") String keyword) {

        List<UserDto.searchUser> userDtoList = userService.searchUser(id, keyword);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("'" + keyword + "'에 대한 검색 결과 입니다.")
                .count(userDtoList.size())
                .result(Arrays.asList(userDtoList.toArray()))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
