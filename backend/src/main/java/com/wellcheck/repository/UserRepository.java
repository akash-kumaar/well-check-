package com.wellcheck.repository;
import com.wellcheck.entity.UserAccount; import java.util.*; import org.springframework.data.jpa.repository.JpaRepository;
public interface UserRepository extends JpaRepository<UserAccount,UUID> { Optional<UserAccount> findByEmailIgnoreCase(String email); }

