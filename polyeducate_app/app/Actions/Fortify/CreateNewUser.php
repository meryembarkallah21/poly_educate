<?php

namespace App\Actions\Fortify;

use App\Models\User;
use App\Models\Professor;
use App\Models\UserDetails;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Laravel\Fortify\Contracts\CreatesNewUsers;
use Laravel\Jetstream\Jetstream;

//this is to register new user or professor

class CreateNewUser implements CreatesNewUsers
{
    use PasswordValidationRules;

    /**
     * Validate and create a newly registered user.
     *
     * @param  array  $input
     * @return \App\Models\User
     */
    public function create(array $input)
    {
        Validator::make($input, [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => $this->passwordRules(),
            'terms' => Jetstream::hasTermsAndPrivacyPolicyFeature() ? ['accepted', 'required'] : '',
        ])->validate();

        $user = User::create([
            'name' => $input['name'],
            'email' => $input['email'],
            'type' => $input['type'],
            'password' => Hash::make($input['password']),
        ]);

        if ($input['type'] == 'professor') {
            $professorInfo = Professor::create([
                'prof_id' => $user->id,
                'status' => 'active'
            ]);
        } else if ($input['type'] == 'user') {
            $userInfo = UserDetails::create([
                'user_id' => $user->id,
                'status' => 'active'
            ]);
        }
        return $user;
    }
}
