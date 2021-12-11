package com.talk2amareswaran.projects.springboot2authserver.entity;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.*;

import org.hibernate.annotations.Type;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

@Entity
@Table(name="user", schema = "avarum_users")
public class User extends BaseIdEntity implements UserDetails {

	private static final long serialVersionUID = 1L;


	private String username;
	@Column(name = "password")
	private String password;
	@Column(name = "gender", columnDefinition = "int2")
	private byte gender;
	@Column(name = "discordid")
	private String discordID;
	@Column(name = "email")
	private String email;

	public byte getGender() {
		return gender;
	}

	public void setGender(byte gender) {
		this.gender = gender;
	}
	@Column(name = "enabled", columnDefinition = "int2")
	@Type(type = "org.hibernate.type.NumericBooleanType")
	private boolean enabled;

	@Column(name = "account_locked", columnDefinition = "int2")
	@Type(type = "org.hibernate.type.NumericBooleanType")
	private boolean accountNonLocked;

	@Column(name = "account_expired", columnDefinition = "int2")
	@Type(type = "org.hibernate.type.NumericBooleanType")
	private boolean accountNonExpired;

	@Column(name = "credentials_expired", columnDefinition = "int2")
	@Type(type = "org.hibernate.type.NumericBooleanType")
	private boolean credentialsNonExpired;

	@ManyToMany(fetch = FetchType.EAGER)
	@JoinTable(name = "role_user", joinColumns = {
			@JoinColumn(name = "user_id", referencedColumnName = "id") }, inverseJoinColumns = {
					@JoinColumn(name = "role_id", referencedColumnName = "id") })
	private List<Role> roles;

	@Override
	public boolean isEnabled() {
		return enabled;
	}

	@Override
	public boolean isAccountNonExpired() {
		return !accountNonExpired;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return !credentialsNonExpired;
	}

	@Override
	public boolean isAccountNonLocked() {
		return !accountNonLocked;
	}

	/*
	 * Get roles and permissions and add them as a Set of GrantedAuthority
	 */
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();

		roles.forEach(r -> {
			authorities.add(new SimpleGrantedAuthority(r.getName()));
			r.getPermissions().forEach(p -> {
				authorities.add(new SimpleGrantedAuthority(p.getName()));
			});
		});

		return authorities;
	}

	@Override
	public String getPassword() {
		return password;
	}

	@Override
	public String getUsername() {
		return username;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

}
