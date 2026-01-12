package com.example.demoauth.config;

import com.nimbusds.jose.jwk.JWKSet;
import com.nimbusds.jose.jwk.RSAKey;
import com.nimbusds.jose.jwk.source.ImmutableJWKSet;
import com.nimbusds.jose.jwk.source.JWKSource;
import com.nimbusds.jose.proc.SecurityContext;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtEncoder;

import java.io.InputStream;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.interfaces.RSAPublicKey;

/**
 * Cấu hình JwtEncoder dùng secret HMAC (HS256) cho nội bộ.
 * Sau này nếu bạn chuyển sang RSA/EC thì thay bean này.
 */
@Configuration
public class JwtConfig {

    @Bean
    public JWKSet jwkSet(
            @Value("${jwt.keystore-location}") Resource keystore,
            @Value("${jwt.keystore-password}") String keystorePassword,
            @Value("${jwt.key-alias}") String keyAlias,
            @Value("${jwt.key-password}") String keyPassword) {
        try {
            KeyStore keyStore = KeyStore.getInstance("JKS");
            try (InputStream is = keystore.getInputStream()) {
                keyStore.load(is, keystorePassword.toCharArray());
            }

            var key = keyStore.getKey(keyAlias, keyPassword.toCharArray());
            if (!(key instanceof PrivateKey privateKey)) {
                throw new IllegalStateException("Key with alias " + keyAlias + " is not a private key");
            }
            var cert = keyStore.getCertificate(keyAlias);
            var publicKey = cert.getPublicKey();
            if (!(publicKey instanceof RSAPublicKey rsaPublicKey)) {
                throw new IllegalStateException("Key with alias " + keyAlias + " is not RSA");
            }

            RSAKey rsaJwk = new RSAKey.Builder(rsaPublicKey)
                    .privateKey(privateKey)
                    .keyID(keyAlias)
                    .build();
            return new JWKSet(rsaJwk);
        } catch (Exception ex) {
            throw new IllegalStateException("Cannot init JWKSet from keystore", ex);
        }
    }

    @Bean
    public JwtEncoder jwtEncoder(
            JWKSet jwkSet) {
        JWKSource<SecurityContext> jwkSource = new ImmutableJWKSet<>(jwkSet);
        return new NimbusJwtEncoder(jwkSource);
    }

    @Bean
    public JwtDecoder jwtDecoder(
            JWKSet jwkSet,
            @Value("${jwt.key-alias}") String keyAlias) {
        try {
            RSAKey rsaKey = (RSAKey) jwkSet.getKeyByKeyId(keyAlias);
            if (rsaKey == null) {
                // fallback: lấy key đầu tiên
                rsaKey = (RSAKey) jwkSet.getKeys().stream()
                        .filter(k -> k instanceof RSAKey)
                        .findFirst()
                        .orElseThrow(() -> new IllegalStateException("No RSA key found in jwkSet"));
            }
            RSAPublicKey publicKey = rsaKey.toRSAPublicKey();
            return NimbusJwtDecoder.withPublicKey(publicKey).build();
        } catch (Exception ex) {
            throw new IllegalStateException("Cannot init JwtDecoder from keystore", ex);
        }
    }
}


