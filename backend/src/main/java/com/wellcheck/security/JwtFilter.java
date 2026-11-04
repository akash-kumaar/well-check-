package com.wellcheck.security;
import jakarta.servlet.*; import jakarta.servlet.http.*; import org.springframework.security.authentication.UsernamePasswordAuthenticationToken; import org.springframework.security.core.authority.SimpleGrantedAuthority; import org.springframework.security.core.context.SecurityContextHolder; import org.springframework.security.web.authentication.preauth.AbstractPreAuthenticatedProcessingFilter; import org.springframework.web.filter.OncePerRequestFilter; import org.springframework.stereotype.Component; import java.io.*; import java.util.*;
@Component public class JwtFilter extends OncePerRequestFilter {
 private final JwtService jwt; public JwtFilter(JwtService jwt){this.jwt=jwt;}
 @Override protected void doFilterInternal(HttpServletRequest r,HttpServletResponse s,FilterChain c)throws ServletException,IOException { String h=r.getHeader("Authorization"); if(h!=null&&h.startsWith("Bearer ")) try {var claims=jwt.parse(h.substring(7)); Object claimedRoles=claims.get("roles"); var roles=(claimedRoles instanceof Collection<?> list?list:List.of()).stream().map(Object::toString).map(x->new SimpleGrantedAuthority("ROLE_"+x)).toList(); var a=new UsernamePasswordAuthenticationToken(claims.getSubject(),null,roles); SecurityContextHolder.getContext().setAuthentication(a);}catch(Exception ignored){} c.doFilter(r,s); }
}

