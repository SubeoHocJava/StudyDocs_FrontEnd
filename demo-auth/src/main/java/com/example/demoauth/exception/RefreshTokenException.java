package com.example.demoauth.exception;

/**
 * Exception cho refresh token errors.
 */
public class RefreshTokenException extends AuthException {

    public static RefreshTokenException expired() {
        return new RefreshTokenException(AuthErrorCodes.REFRESH_TOKEN_EXPIRED, "Refresh token has expired");
    }

    public static RefreshTokenException revoked() {
        return new RefreshTokenException(AuthErrorCodes.REFRESH_TOKEN_REVOKED, "Refresh token has been revoked");
    }

    public static RefreshTokenException invalid() {
        return new RefreshTokenException(AuthErrorCodes.REFRESH_TOKEN_INVALID, "Refresh token is invalid");
    }

    public static RefreshTokenException notFound() {
        return new RefreshTokenException(AuthErrorCodes.REFRESH_TOKEN_NOT_FOUND, "Refresh token not found");
    }

    private RefreshTokenException(int errorCode, String message) {
        super(org.springframework.http.HttpStatus.UNAUTHORIZED, errorCode, message);
    }
}

