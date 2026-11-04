package com.wellcheck.service;
import org.springframework.jdbc.core.JdbcTemplate; import org.springframework.security.core.Authentication; import org.springframework.stereotype.Service; import java.util.*;
@Service public class AuditService { private final JdbcTemplate jdbc; public AuditService(JdbcTemplate jdbc){this.jdbc=jdbc;} public void record(Authentication a,String action,String type,UUID id){String actor=a==null?null:a.getName(); jdbc.update("INSERT INTO audit_logs(actor_id,action,resource_type,resource_id) VALUES (cast(? as uuid),?,?,?)",actor,action,type,id);}}

