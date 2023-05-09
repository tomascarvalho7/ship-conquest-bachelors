package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.user.UserInfo

data class UserInfoDBModel(val username: String, val name: String, val email: String, val imageUrl: String?, val description: String?)

fun UserInfoDBModel.toUserInfo() = UserInfo(username, name, email, imageUrl, description)