package com.example.demoauth.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Filter đọc Authorization: Bearer <token>, giải JWT nội bộ,
 * set Authentication để các service/API khác dùng chung.
 */
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtDecoder jwtDecoder;

    public JwtAuthenticationFilter(JwtDecoder jwtDecoder) {
        this.jwtDecoder = jwtDecoder;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String header = request.getHeader(HttpHeaders.AUTHORIZATION);
        if (!StringUtils.hasText(header) || !header.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = header.substring(7);
        try {
            Jwt jwt = jwtDecoder.decode(token);

            // Lấy roles/permissions từ claims để set vào authorities
            Collection<SimpleGrantedAuthority> authorities = extractAuthorities(jwt);

            String principal = jwt.getSubject(); // userId
            String name = jwt.getClaimAsString("name"); // displayName nếu có

            UsernamePasswordAuthenticationToken authentication =
                    new UsernamePasswordAuthenticationToken(principal, null, authorities);
            authentication.setDetails(Map.of(
                    "name", name,
                    "tokenId", jwt.getId()
            ));

            SecurityContextHolder.getContext().setAuthentication(authentication);
        } catch (JwtException ex) {
            // Token không hợp lệ: bỏ qua, để request tiếp tục (sẽ bị 401 ở layer authorize)
            SecurityContextHolder.clearContext();
        }

        filterChain.doFilter(request, response);
    }

    private Collection<SimpleGrantedAuthority> extractAuthorities(Jwt jwt) {
        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
    
        Object roles = jwt.getClaims().get("roles");
        if (roles instanceof Collection<?> r) {
            r.stream()
             .filter(String.class::isInstance)
             .map(String.class::cast)
             .map(SimpleGrantedAuthority::new)
             .forEach(authorities::add);
        }
    
        Object perms = jwt.getClaims().get("permissions");
        if (perms instanceof Collection<?> p) {
            p.stream()
             .filter(String.class::isInstance)
             .map(String.class::cast)
             .map(SimpleGrantedAuthority::new)
             .forEach(authorities::add);
        }
    
        return authorities;
    }
    
}


