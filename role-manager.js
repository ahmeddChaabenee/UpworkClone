// Role Management System
function setRole(role) {
    localStorage.setItem('userRole', role);
    location.reload();
}

function getCurrentRole() {
    return localStorage.getItem('userRole') || 'guest';
}

function updateUIByRole() {
    const role = getCurrentRole();
    
    // Hide/show "Find Talent" based on role
    const findTalentLinks = document.querySelectorAll('[data-role-hide="freelancer"]');
    findTalentLinks.forEach(el => {
        el.style.display = role === 'freelancer' ? 'none' : 'inline-block';
    });
    
    // Hide/show "Find Work" based on role
    const findWorkLinks = document.querySelectorAll('[data-role-hide="client"]');
    findWorkLinks.forEach(el => {
        el.style.display = role === 'client' ? 'none' : 'inline-block';
    });
    
    // Show/hide role-specific content
    const freelancerContent = document.querySelectorAll('[data-role="freelancer"]');
    freelancerContent.forEach(el => {
        el.style.display = role === 'freelancer' ? 'block' : 'none';
    });
    
    const clientContent = document.querySelectorAll('[data-role="client"]');
    clientContent.forEach(el => {
        el.style.display = role === 'client' ? 'block' : 'none';
    });
    
    // Show only for specific role using data-role-show
    const guestOnlyContent = document.querySelectorAll('[data-role-show="guest"]');
    guestOnlyContent.forEach(el => {
        el.style.display = role === 'guest' ? 'inline-block' : 'none';
    });
    
    // Update role indicator
    const roleIndicator = document.getElementById('roleIndicator');
    if (roleIndicator) {
        roleIndicator.textContent = role.charAt(0).toUpperCase() + role.slice(1);
    }
}

// Call on page load
document.addEventListener('DOMContentLoaded', updateUIByRole);

// Role-based navigation functions
function redirectToPostJob() {
    const role = getCurrentRole();
    if (role === 'guest') {
        window.location.href = 'signup.html';
    } else {
        window.location.href = 'post-work-form.html';
    }
}

function redirectToApplyJob() {
    const role = getCurrentRole();
    if (role === 'guest') {
        window.location.href = 'signup.html';
    } else {
        window.location.href = 'apply-work-form.html';
    }
}
