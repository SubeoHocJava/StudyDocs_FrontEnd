package com.example.demoauth.exception;

/**
 * Auth error codes: reserved range 0..99.
 *
 * <p>
 * Notes:
 * <ul>
 * <li>Success should use {@code errorCode = null}.</li>
 * <li>Client maps {@code errorCode} to a user-friendly message.</li>
 * </ul>
 */
public final class AuthErrorCodes {
    private AuthErrorCodes() {
    }

    /** Username/password invalid (login local). */
    public static final int INVALID_CREDENTIALS = 1;

    /** Username already exists (register local). */
    public static final int USERNAME_EXISTS = 2;

    /** Email already exists (register local). */
    public static final int EMAIL_EXISTS = 3;

    /**
     * User not found (e.g., /me with a valid JWT subject but missing user record).
     */
    public static final int USER_NOT_FOUND = 4;

    /** Unsupported OAuth provider. */
    public static final int UNSUPPORTED_PROVIDER = 5;

    /** Invalid OAuth provider token (Google/Facebook...). */
    public static final int INVALID_PROVIDER_TOKEN = 6;

    /** Refresh token expired. */
    public static final int REFRESH_TOKEN_EXPIRED = 10;

    /** Refresh token revoked (rotation). */
    public static final int REFRESH_TOKEN_REVOKED = 11;

    /** Refresh token invalid (bad signature/claims/type). */
    public static final int REFRESH_TOKEN_INVALID = 12;

    /** Refresh token not found in DB. */
    public static final int REFRESH_TOKEN_NOT_FOUND = 13;

    /** Access token invalid/expired -> 401 (Spring Security). */
    public static final int ACCESS_TOKEN_INVALID_OR_EXPIRED = 90;

    /** Authenticated but not authorized -> 403 (Spring Security). */
    public static final int FORBIDDEN = 91;

    /** Unknown auth error (fallback). */
    public static final int AUTH_UNKNOWN = 99;
}
