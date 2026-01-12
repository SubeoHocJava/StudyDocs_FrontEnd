package com.example.demoauth.exception;

/**
 * Common (non-auth-reserved) error codes.
 *
 * <p>Auth reserves 0..99. Everything here should stay outside that range.
 */

public final class CommonErrorCodes {
    private CommonErrorCodes() {}

    /* ========== Auth Service Common Errors (50-99) ========== */
    
    /** Request validation failed (e.g. @Valid). */
    public static final int VALIDATION_FAILED = 50;

    /** Generic bad request. */
    public static final int BAD_REQUEST = 51;

    /** Role not found. */
    public static final int ROLE_NOT_FOUND = 52;

    /** Permission not found. */
    public static final int PERMISSION_NOT_FOUND = 53;

    /** Permission already exists. */
    public static final int PERMISSION_ALREADY_EXISTS = 54;

    /* ========== System Errors (500+) ========== */
    
    /** Unhandled server error. */
    public static final int INTERNAL_ERROR = -1;
}

