document.addEventListener('DOMContentLoaded', function() {
    const toastElList = document.querySelectorAll('.toast');
    const toastList = Array.from(toastElList).map(toastEl => new bootstrap.Toast(toastEl, {
      autohide: true, 
      delay: 5000    
    }));
  
    // Optionally, you can show all toasts immediately
    toastList.forEach(toast => toast.show());
  });