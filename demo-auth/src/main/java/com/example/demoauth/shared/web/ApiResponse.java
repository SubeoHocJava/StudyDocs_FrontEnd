package com.example.demoauth.shared.web;

/**
 * Unified API response wrapper.
 *
 * <p>Conventions:
 * <ul>
 *   <li>Success: statusCode=200 (or other 2xx), errorCode=null, data!=null, traceId=null (for now)</li>
 *   <li>Error: statusCode=HTTP status, errorCode!=null, data=null, traceId=null (for now)</li>
 * </ul>
 */
public record ApiResponse<T>(int statusCode, Integer errorCode, T data, String traceId) {
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(200, null, data, null);
    }

    public static <T> ApiResponse<T> success(int statusCode, T data) {
        return new ApiResponse<>(statusCode, null, data, null);
    }

    public static <T> ApiResponse<T> error(int statusCode, Integer errorCode) {
        return new ApiResponse<>(statusCode, errorCode, null, null);
    }
}


