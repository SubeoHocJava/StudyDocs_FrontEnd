package com.example.demoauth.remote;

import com.example.demoauth.dto.UserRequestAPI;
import com.example.demoauth.exception.AuthErrorCodes;
import com.example.demoauth.exception.AuthException;
import com.example.demoauth.exception.RequestApiException;
import com.example.demoauth.shared.web.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class RemoteUserService {
    private final RemoteApiCaller remoteApiCaller;
    @Value("${app.remote.user-url}")
    private String userUrl;

    public void call(UserRequestAPI user, String accToken) {
        ApiResponse<Object> result = remoteApiCaller.post(userUrl, user, MediaType.APPLICATION_JSON, accToken, new ParameterizedTypeReference<>() {
        });
        if (result.errorCode() == null)
            return;
        else
            throw new RequestApiException(result.statusCode(), result.errorCode());

    }
}
