<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use App\Models\User;
use App\Models\Professor;
use App\Models\UserDetails;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;





class UsersController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $user = array(); //this will return a set of user and professor data
        $user = Auth::user();
        $professor = User::where('type', 'professor')->get();
        $details = $user->user_details;
        $professorData = Professor::all();
        //this is the date format without leading
        $date = now()->format('n/j/Y'); //change date format to suit the format in database
        //make this appointment filter only status is "upcoming"
        $appointment = Appointments::where('status', 'upcoming')->where('date', $date)->first();

        //collect user data and all professor details
        foreach($professorData as $data){
            //sorting professor name and professor details
            foreach($professor as $info){
                if($data['prof_id'] == $info['id']){
                    $data['professor_name'] = $info['name'];
                    $data['professor_profile'] = $info['profile_photo_url'];
                     if(isset($appointment) && $appointment['prof_id'] == $info['id']){
                        $data['appointments'] = $appointment;
                    }
                }
            }
        }

        $user['professor'] = $professorData;
        $user['details'] = $details; //return user details here together with professor list

        return $user; //return all data 
    }

    /**
     * loign.
     *
     * @return \Illuminate\Http\Response
     */
    public function login(Request $reqeust)
    {
        //validate incoming inputs
        $reqeust->validate([
            'email'=>'required|email',
            'password'=>'required',
        ]);

        //check matching user
        $user = User::where('email', $reqeust->email)->first();

        //check password
        if(!$user || ! Hash::check($reqeust->password, $user->password)){
            throw ValidationException::withMessages([
                'email'=>['The provided credentials are incorrect'],
            ]);
        }

        //then return generated token
        return $user->createToken($reqeust->email)->plainTextToken;
    }

    /**
     * register.
     *
     * @return \Illuminate\Http\Response
     */
    public function register(Request $request)
    {
        //validate incoming inputs
        $request->validate([
            'name'=>'required|string',
            'email'=>'required|email',
            'password'=>'required',
        ]);

        $user = User::create([
            'name'=>$request->name,
            'email'=>$request->email,
            'type'=>'user',
            'password'=>Hash::make($request->password),
        ]);

        $userInfo = UserDetails::create([
            'user_id'=>$user->id,
            'status'=>'active',
        ]);

        return $user;

    }

    /**
     * update favorite professor list
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function storeFavProf(Request $request)
    {

        $saveFav = UserDetails::where('user_id',Auth::user()->id)->first();

        $profList = json_encode($request->get('favList'));

        //update fav list into database
        $saveFav->fav = $profList;  //and remember update this as well
        $saveFav->save();

        return response()->json([
            'success'=>'The Favorite List is updated',
        ], 200);
    }

    
    public function logout(){
        $user = Auth::user();
        $user->currentAccessToken()->delete();

        return response()->json([
            'success'=>'Logout successfully!',
        ], 200);
    } 

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
