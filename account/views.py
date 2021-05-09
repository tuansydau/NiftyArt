from django.shortcuts import render

from .forms import RegistrationForm


def account_register(request):

    # Check to see that user is authenticated before registering
    if reuqest.user.is_authenticated:
        # If they are logged in, bring user to homepage
        return redirect('/')

    # Make sure that whoever is registering has posted data
    if request.method == 'POST':
        # Put the user data into a variable
        registerForm = RegistrationForm(request.POST)
        if registerForm.is_valid():
            user = registerForm.cleaned_data('email')
            user.email = registerForm.cleaned_data['email']
            user.set_password(registerForm.cleaned_data['password'])
            user.is_active = False
            user.save()
            current_site = get_current_site(request)
            subject = 'Activate your Account'
            message = render_to_string('account/registration/account_activation_email.html', {
                'user': user,
                'domain': current_site.domain,
                'uid': urlsafe_base64_encode(force_bytes(user.pk)),
                'token': account_activation_token.make_token(user),
            })
            user.email_user(subject=subject, message=message)
            return HttpResponse('registered succesfully and activation sent')
    else:
        registerForm = RegistrationForm()
    return render(request, 'account/registration/register.html', {'form': registerForm})

# Create your views here.
