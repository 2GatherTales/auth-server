package com.gathertales.authservice.repository;

import com.gathertales.authservice.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.CrossOrigin;

import javax.transaction.Transactional;

@Repository
@Transactional
@CrossOrigin(origins = "http://localhost:4020", maxAge = 3600)
public interface UserRepository extends JpaRepository<User, Long> {

	User findByUsername(String username);

}


