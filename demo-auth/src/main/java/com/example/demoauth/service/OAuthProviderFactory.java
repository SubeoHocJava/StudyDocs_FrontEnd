package com.example.demoauth.service;

import com.example.demoauth.exception.AuthErrorCodes;
import com.example.demoauth.exception.AuthException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Factory/registry để chọn OAuthProviderService theo tên provider.
 */
@Component
public class OAuthProviderFactory {

    private final Map<String, OAuthProviderService> providers = new HashMap<>();

    public OAuthProviderFactory(List<OAuthProviderService> providerServices) {
        for (OAuthProviderService service : providerServices) {
            providers.put(service.getProviderName().toLowerCase(), service);
        }
    }

    public OAuthProviderService getProvider(String providerName) {
        OAuthProviderService service = providers.get(providerName.toLowerCase());
        if (service == null) {
            throw new AuthException(HttpStatus.BAD_REQUEST, AuthErrorCodes.UNSUPPORTED_PROVIDER, "Unsupported provider: " + providerName);
        }
        return service;
    }
}


