document.addEventListener('DOMContentLoaded', function() {
    const passwordField = document.getElementById('password-field');
    const togglePassword = document.getElementById('toggle-password');

    togglePassword.addEventListener('click', function () {
        if (passwordField.type === 'password') {
            passwordField.type = 'text';
        } else {
            passwordField.type = 'password';
        }
    });
});

document.addEventListener('DOMContentLoaded', function() {
    const passwordConfirmField = document.getElementById('password-confirm-field');
    const togglePassword = document.getElementById('toggle-confirm-password');

    togglePassword.addEventListener('click', function () {
        if (passwordConfirmField.type === 'password') {
            passwordConfirmField.type = 'text';
        } else {
            passwordConfirmField.type = 'password';
        }
    });
});