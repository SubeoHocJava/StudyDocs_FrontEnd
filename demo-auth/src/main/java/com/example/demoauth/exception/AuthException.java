package com.example.demoauth.exception;

import org.springframework.http.HttpStatus;

/**
 * Auth-domain exception. Internal error codes are reserved in range 0..99.
 */
public class AuthException extends ApiException {
    public AuthException(HttpStatus httpStatus, int errorCode) {
        super(httpStatus, errorCode);
    }

    public AuthException(HttpStatus httpStatus, int errorCode, String message) {
        super(httpStatus, errorCode, message);
    }

    public AuthException(HttpStatus httpStatus, int errorCode, String message, Throwable cause) {
        super(httpStatus, errorCode, message, cause);
    }
}


