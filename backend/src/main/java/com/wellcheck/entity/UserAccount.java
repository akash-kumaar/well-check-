package com.wellcheck.entity;
import jakarta.persistence.*; import java.time.Instant; import java.util.*;
@Entity @Table(name="users") public class UserAccount {
 @Id public UUID id=UUID.randomUUID(); @Column(nullable=false,unique=true) public String email; @Column(name="password_hash",nullable=false) public String passwordHash; @Column(name="display_name",nullable=false) public String displayName; public boolean active=true; @Column(name="created_at") public Instant createdAt=Instant.now(); @Column(name="updated_at") public Instant updatedAt=Instant.now();
 @ManyToMany(fetch=FetchType.EAGER) @JoinTable(name="user_roles",joinColumns=@JoinColumn(name="user_id"),inverseJoinColumns=@JoinColumn(name="role_id")) public Set<Role> roles=new HashSet<>();
}

