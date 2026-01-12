package com.example.demoauth.exception;

import org.springframework.http.HttpStatus;

/**
 * Base exception carrying HTTP status + internal error code.
 *
 * <p>Message is meant for server-side logs only and must NOT be returned to client.</p>
 */
public class ApiException extends RuntimeException {

    private final HttpStatus httpStatus;
    private final int errorCode;

    public ApiException(HttpStatus httpStatus, int errorCode) {
        super();
        this.httpStatus = httpStatus;
        this.errorCode = errorCode;
    }

    public ApiException(HttpStatus httpStatus, int errorCode, String message) {
        super(message);
        this.httpStatus = httpStatus;
        this.errorCode = errorCode;
    }

    public ApiException(HttpStatus httpStatus, int errorCode, String message, Throwable cause) {
        super(message, cause);
        this.httpStatus = httpStatus;
        this.errorCode = errorCode;
    }

    public HttpStatus getHttpStatus() {
        return httpStatus;
    }

    public int getErrorCode() {
        return errorCode;
    }
}


