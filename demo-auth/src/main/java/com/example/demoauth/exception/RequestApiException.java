package com.example.demoauth.exception;


import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Data
public class RequestApiException extends ApiException {
    public RequestApiException(int status, int errorCode) {
        super(HttpStatus.valueOf(status), errorCode);
    }
}

