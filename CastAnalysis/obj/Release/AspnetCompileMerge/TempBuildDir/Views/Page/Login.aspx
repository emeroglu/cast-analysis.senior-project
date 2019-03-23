<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html>

<html lang="en">
<head>

    <meta name="google-signin-scope" content="profile email https://www.googleapis.com/auth/analytics">
    <meta name="google-signin-client_id" content="104840348047-1f039sigebddbhco4kguqjbfnto95ovj.apps.googleusercontent.com">

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0" />

    <title>CastAnalysis | Login</title>

    <link href="/Template/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />

    <link href="/Template/assets/css/main.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/responsive.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/icons.css" rel="stylesheet" type="text/css" />

    <link href="/Template/assets/css/login.css" rel="stylesheet" type="text/css" />

    <link rel="stylesheet" href="/Template/assets/css/fontawesome/font-awesome.min.css">
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,600,700' rel='stylesheet' type='text/css'>

    <script type="text/javascript" src="/Template/assets/js/libs/jquery-1.10.2.min.js"></script>

    <script type="text/javascript" src="/Template/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/Template/assets/js/libs/lodash.compat.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/uniform/jquery.uniform.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/validation/jquery.validate.min.js"></script>

    <script type="text/javascript" src="/Template/plugins/nprogress/nprogress.js"></script>

    <script type="text/javascript" src="/Template/assets/js/login.js"></script>
    <script>
        $(document).ready(function () {
            "use strict";

            Login.init(); // Init login JavaScript
        });
    </script>

    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <script src="https://code.angularjs.org/1.5.0-rc.2/angular.js"></script>

    <script type="text/javascript">

        angular.module('fc', [])

        .controller("Ctrl", function ($scope, $http) {

            var id;

            $scope.onSignIn = function (googleUser) {

                var profile = googleUser.getBasicProfile();

                $http.post("/Service/LogTheUserIn", {

                    googleId: profile.getId(),
                    name: profile.getName(),
                    email: profile.getEmail()

                }).success(function (data) {

                    id = data;
                    $("#btn").css("display", "initial");

                });

            };

            $scope.redirect = function () {

                location.href = "/Page/Dashboard/" + id;

            };

        });

    </script>
</head>

<body ng-app="fc" ng-controller="Ctrl" class="login" id="body">

    <div class="logo">
        <img src="/Template/assets/img/logo.png" alt="logo" />
        <strong>Cast</strong>Analysis
    </div>

    <div class="box">
        <div class="content" style="padding-bottom: 60px;">
            <form class="form-vertical login-form">
                <div class="g-signin2" data-onsuccess="onSignIn" data-theme="dark" style="margin-left: 30%;"></div>
                <div value="Enter" id="btn" style="display: none; width: 120px; height: 35px; border: none; color: white; background-color: #4d7496; float: left; text-align: center; line-height: 35px; margin-left: 30%; margin-top: 5px; cursor: pointer;"
                    ng-click="redirect()">
                    Enter
                </div>
            </form>
        </div>
    </div>

    <script>
        function onSignIn(googleUser) {

            angular.element(document.getElementById("body")).scope().onSignIn(googleUser);

        };

    </script>
</body>
</html>
