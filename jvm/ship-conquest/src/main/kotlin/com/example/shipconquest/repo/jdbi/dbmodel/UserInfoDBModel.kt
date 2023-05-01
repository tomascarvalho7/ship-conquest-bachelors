package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.user.UserInfo

data class UserInfoDBModel(val name: String, val email: String, val imageUrl: String)

fun UserInfoDBModel.toUserInfo() = UserInfo(name, email, imageUrl)