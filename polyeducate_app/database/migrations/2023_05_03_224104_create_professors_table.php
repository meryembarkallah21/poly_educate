<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //create a database table for professor
        //and this professor table is refer to User table
        //when a new professor registered, the professor details will be created as well
        Schema::create('professors', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('prof_id')->unique();
            $table->string('category')->nullable();
            $table->unsignedInteger('students')->nullable();
            $table->unsignedInteger('experience')->nullable();
            $table->longText('bio_data')->nullable();
            $table->string('status')->nullable();
          // this states that the prof_id refers to id on users table
            $table->foreign('prof_id')->references('id')->on('users')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('professors');
    }
};
