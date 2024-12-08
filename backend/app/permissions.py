from rest_framework import permissions


class IsSupportUser(permissions.BasePermission):
    """
    Allows access only to support users.
    """

    def has_permission(self, request, view):
        return request.user.is_authenticated and request.user.is_support_user


class IsRegularUser(permissions.BasePermission):
    """
    Allows access only to regular users.
    """

    def has_permission(self, request, view):
        return request.user.is_authenticated and not request.user.is_support_user
