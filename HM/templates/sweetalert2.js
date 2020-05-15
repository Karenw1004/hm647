$(function() {
    const Toast = Swal.mixin({
    toast: true,
    position: 'top',
    showConfirmButton: false,
    timer: 4000
    });
    {% with messages = get_flashed_messages(with_categories=true) %}
        {% if messages %}
        {% for category, message in messages %}
        let msg = '{{ message| capitalize }}';
        let cat = '{{category}}';

        if (msg != ''){
            if (cat == "success"){
                Toast.fire({
                    "type": 'success',
                    "title": msg
                });
            } 
            else if (cat == "error"){
                Toast.fire({
                    "type": 'error',
                    "title": msg
                });
            }
            else if (cat == "warning"){
                Toast.fire({
                    "type": 'warning',
                    "title": msg
                });
            }
            else if (cat == "info"){
                Toast.fire({
                    "type": 'info',
                    "title": msg
                });
            }
        }

        {% endfor %}
    {% endif %}
    {% endwith %}
    

});