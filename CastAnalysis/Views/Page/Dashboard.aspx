<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>CastAnalysis</title>

    <link rel="shortcut icon" type="image/x-icon" href="/Template/assets/img/logo.png" />

    <link href="/Template/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />

    <link href="/Template/assets/css/main.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/responsive.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/icons.css" rel="stylesheet" type="text/css" />

    <link rel="stylesheet" href="/Template/assets/css/fontawesome/font-awesome.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,600,700' rel='stylesheet' type='text/css'>

    <script type="text/javascript" src="/Template/assets/js/libs/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/jquery-ui/jquery-ui-1.10.2.custom.min.js"></script>

    <script type="text/javascript" src="/Template/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/Template/assets/js/libs/lodash.compat.min.js"></script>

    <script type="text/javascript" src="/Template/plugins/touchpunch/jquery.ui.touch-punch.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/event.swipe/jquery.event.move.js"></script>
    <script type="text/javascript" src="/Template/plugins/event.swipe/jquery.event.swipe.js"></script>

    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <script src="https://code.angularjs.org/1.5.0-rc.2/angular.js"></script>

    <script type="text/javascript">
        
        var googleUserId = "<%: ViewBag.GoogleID %>";

        var appReady = true;

        angular.module('fc', [])

        .controller("Ctrl", function ($scope, $http) {

            $scope.accounts = [];

            $scope.signOut = function () {

                location.href = "/";

            };

            var CLIENT_ID = '246693846494-mgm7c9nqvvkt34qqvpshj6chanc8en9h.apps.googleusercontent.com';

            var SCOPES = ['https://www.googleapis.com/auth/analytics.readonly'];

            $scope.onload = function () {

                $scope.authorize();

            };

            $scope.authorize = function () {

                var authData = {
                    client_id: CLIENT_ID,
                    scope: SCOPES,
                    immediate: false
                };

                gapi.auth.authorize(authData, function (response) { $scope.queryAccounts(); });

            };

            $scope.queryAccounts = function () {

                gapi.client.load('analytics', 'v3').then(function () {
                    gapi.client.analytics.management.accounts.list().then($scope.handleAccounts);
                });

            };

            $scope.handleAccounts = function (response) {

                $scope.accounts = response.result.items;
                $scope.$apply();

                var json = [];

                for (var i = 0; i < $scope.accounts.length; i++) {

                    json.push({

                        id: $scope.accounts[i].id,
                        name: $scope.accounts[i].name

                    });

                }

                $http.post("/Service/SaveAccounts/" + googleUserId, {

                    p2: json

                }).success(function (data) {

                    appReady = true;

                });

            };

            $scope.expand = function () {

                document.getElementsByClassName("project-list")[0].style.width = "100%";

            };

        });

    </script>

    <script type="text/javascript" src="/Template/assets/js/libs/breakpoints.js"></script>
    <script type="text/javascript" src="/Template/plugins/respond/respond.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/cookie/jquery.cookie.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/slimscroll/jquery.slimscroll.horizontal.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/sparkline/jquery.sparkline.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/flot/jquery.flot.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/flot/jquery.flot.tooltip.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/flot/jquery.flot.resize.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/flot/jquery.flot.time.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/flot/jquery.flot.growraf.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/easy-pie-chart/jquery.easy-pie-chart.min.js"></script>

    <script type="text/javascript" src="/Template/plugins/daterangepicker/moment.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/daterangepicker/daterangepicker.js"></script>
    <script type="text/javascript" src="/Template/plugins/blockui/jquery.blockUI.min.js"></script>

    <script type="text/javascript" src="/Template/plugins/fullcalendar/fullcalendar.min.js"></script>

    <script type="text/javascript" src="/Template/plugins/noty/jquery.noty.js"></script>
    <script type="text/javascript" src="/Template/plugins/noty/layouts/top.js"></script>
    <script type="text/javascript" src="/Template/plugins/noty/themes/default.js"></script>

    <script type="text/javascript" src="/Template/plugins/uniform/jquery.uniform.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/select2/select2.min.js"></script>

    <script type="text/javascript" src="/Template/assets/js/app.js"></script>
    <script type="text/javascript" src="/Template/assets/js/plugins.js"></script>
    <script type="text/javascript" src="/Template/assets/js/plugins.form-components.js"></script>

</head>
<body ng-app="fc" ng-controller="Ctrl" id="body">
    <header class="header navbar navbar-fixed-top" role="banner">
        <div class="container">

            <ul class="nav navbar-nav">
                <li class="nav-toggle"><a href="javascript:void(0);" title=""><i class="icon-reorder"></i></a></li>
            </ul>

            <a class="navbar-brand" href="index.html">
                <img src="/Template/assets/img/logo.png" alt="logo" />
                <strong>Cast</strong>Analysis
            </a>

            <ul class="nav navbar-nav navbar-right">

                <li class="dropdown">
                    <a href="#" class="project-switcher-btn dropdown-toggle" ng-click="expand()">
                        <i class="fa fa-globe"></i>
                        <span>Accounts</span>
                    </a>
                </li>

                <li class="dropdown user">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="icon-male"></i>
                        <span class="username"><%: ViewBag.Name %></span>
                        <i class="icon-caret-down small"></i>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="#" ng-click="signOut()"><i class="icon-key"></i>Log Out</a></li>
                    </ul>
                </li>

            </ul>

        </div>

        <div id="project-switcher" class="container project-switcher">
            <div id="scrollbar">
                <div class="handle"></div>
            </div>

            <div id="frame">
                <ul class="project-list" style="width: 100%;">
                    <li ng-repeat="account in accounts">
                        <a href="/Page/Account/{{account.id}}">
                            <span class="image"><i class="icon-male"></i></span>
                            <span class="title">{{account.name}}</span>
                        </a>
                    </li>
                </ul>
            </div>

        </div>

    </header>

    <div id="container" class="fixed-header">
    </div>

    <button id="auth-button" hidden style="display: none;">Authorize</button>

    <script type="text/javascript">

        function init() {

            angular.element(document.getElementById("body")).scope().onload();

        }

        function Start() {

            if (appReady) {

                App.init();
                Plugins.init();
                FormComponents.init();

            }
            else {

                setTimeout(function () { Start(); }, 1000);

            }

        }

        Start();

    </script>

    <script src="https://apis.google.com/js/client.js?onload=init"></script>

</body>
</html>
