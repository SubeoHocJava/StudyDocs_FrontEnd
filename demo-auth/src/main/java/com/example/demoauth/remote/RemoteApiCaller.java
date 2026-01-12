package com.example.demoauth.remote;

import com.example.demoauth.shared.web.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;


@Component
@RequiredArgsConstructor
public class RemoteApiCaller {

    private final RestTemplate restTemplate;

    public <T> ApiResponse<T> post(
            String url,
            Object request,
            MediaType headerType,
            String accessToken,
            ParameterizedTypeReference<ApiResponse<T>> responseType
    ) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(headerType);
        headers.setBearerAuth(accessToken);

        HttpEntity<Object> entity = new HttpEntity<>(request, headers);

        ResponseEntity<ApiResponse<T>> response = restTemplate.exchange(
                url,
                HttpMethod.POST,
                entity,
                responseType
        );

        return response.getBody();
    }


    public <T> ApiResponse<T> get(
            String url,
            ParameterizedTypeReference<ApiResponse<T>> responseType
    ) {
        ResponseEntity<ApiResponse<T>> response =
                restTemplate.exchange(
                        url,
                        HttpMethod.GET,
                        null,
                        responseType
                );

        return response.getBody();
    }
    public void postWithoutResponse(String url, Object request) {
        restTemplate.postForLocation(url, request);
    }
    public <T> ResponseEntity<T> exchange(
            String url,
            HttpMethod method,
            HttpEntity<?> requestEntity,
            Class<T> responseType
    ) {
        return restTemplate.exchange(url, method, requestEntity, responseType);
    }
}