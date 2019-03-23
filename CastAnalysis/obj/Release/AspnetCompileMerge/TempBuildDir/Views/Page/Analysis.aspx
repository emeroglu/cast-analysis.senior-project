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

    <script src="/Scripts/regression.js"></script>
    <script src="https://code.angularjs.org/1.5.0-rc.2/angular.js"></script>

    <script type="text/javascript">

        var googleUserId = "<%: ViewBag.User.GoogleID %>";
        var accountId = "<%: ViewBag.AccountID %>";

        var appReady = false;

        var sessions = [], data = [], data2 = [], curve = [], curve2 = [];

        angular.module('fc', [])

        .controller("Ctrl", function ($scope, $http, $timeout) {

            $scope.signOut = function () {

                location.href = "/";

            };

            var CLIENT_ID = '246693846494-mgm7c9nqvvkt34qqvpshj6chanc8en9h.apps.googleusercontent.com';

            var SCOPES = ['https://www.googleapis.com/auth/analytics.readonly'];

            $scope.init = function () {

                $scope.header = "Next Month's Projection";

                $scope.authorize();

            };

            $scope.authorize = function () {

                var authData = {
                    client_id: CLIENT_ID,
                    scope: SCOPES,
                    immediate: true
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

                if (response.result.items && response.result.items.length) {
                    var firstAccountId = response.result.items[0].id;
                    $scope.queryProperties(firstAccountId);
                } else {
                    console.log('No accounts found for this user.');
                }

            };

            $scope.queryProperties = function (accountId) {
                gapi.client.analytics.management.webproperties.list(
                    { 'accountId': accountId })
                  .then($scope.handleProperties)
                  .then(null, function (err) {
                      console.log(err);
                  });
            };

            $scope.handleProperties = function (response) {

                if (response.result.items && response.result.items.length) {
                    var firstAccountId = response.result.items[0].accountId;
                    var firstPropertyId = response.result.items[0].id;
                    $scope.queryProfiles(firstAccountId, firstPropertyId);
                } else {
                    console.log('No properties found for this user.');
                }

            };

            $scope.queryProfiles = function (accountId, propertyId) {

                gapi.client.analytics.management.profiles.list({
                    'accountId': accountId,
                    'webPropertyId': propertyId
                })
                .then($scope.handleProfiles)
                .then(null, function (err) {
                    console.log(err);
                });
            };

            $scope.handleProfiles = function (response) {
                if (response.result.items && response.result.items.length) {
                    var firstProfileId = response.result.items[0].id;
                    $scope.queryCoreReportingApi(firstProfileId);
                } else {
                    console.log('No views (profiles) found for this user.');
                }
            };

            $scope.queryCoreReportingApi = function (profileId) {

                gapi.client.analytics.data.ga.get({
                    'ids': 'ga:' + profileId,
                    'start-date': '2014-01-01',
                    'end-date': '2016-01-01',
                    'metrics': 'ga:pageviews',
                    'dimensions': 'ga:pagePath,ga:deviceCategory,ga:year,ga:month',
                    'filters': 'ga:pagePath==/'
                })
                .then(function (response) {

                    sessions = response.result.rows;

                    $scope.pages = [];

                    var exists = false;

                    for (var i = 0; i < sessions.length; i++) {

                        for (var j = 0; j < $scope.pages.length; j++) {

                            if ($scope.pages[j] == sessions[i][0] || $scope.pages[j] == "Main Page") {
                                exists = true;
                                break;
                            }

                        }

                        if (exists) {
                            exists = false;
                            continue;
                        }
                        else {

                            if (sessions[i][0] == "/")
                                $scope.pages.push("Main Page");
                            else
                                $scope.pages.push(sessions[i][0]);

                        }

                    }

                    $scope.currentPage = $scope.pages[0];

                    $scope.$apply();

                    appReady = true;

                })
                .then(null, function (err) {
                    console.log(err);
                });
            }

            $scope.start = function () {

                if (appReady) {

                    App.init();
                    Plugins.init();
                    FormComponents.init();

                    $("#chart1").css("display", "initial");
                    $("#chart2").css("display", "initial");

                    $scope.currentType = "linear";
                    $scope.project("/", "fit");

                }
                else {
                    $timeout(function () { $scope.start(); }, 1000);
                }

            };

            $scope.project = function (page, draw) {

                if (draw == "fit")
                    $scope.header = "Last Year's Curve";
                else if (draw == "projection")
                    $scope.header = "Next Year's Projection";
                else if (draw == "comparison")
                    $scope.header = "Last 2 Years' Comparison";

                if (page == "Main Page")
                    page = "/";

                $scope.currentPage = page;
                $scope.currentDrawing = draw;

                $scope.reorganize($scope.currentPage, "desktop", $scope.currentDrawing);
                $scope.forecast($scope.currentType, $scope.currentDrawing);

                if ($scope.currentDrawing == "comparison")
                    $scope.error("desktop");

                $scope.graph("#desktopChart", "blue", "Total Desktop Views", $scope.currentDrawing);

                $scope.reorganize($scope.currentPage, "mobile", $scope.currentDrawing);
                $scope.forecast($scope.currentType, $scope.currentDrawing);

                if ($scope.currentDrawing == "comparison")
                    $scope.error("mobile");

                $scope.graph("#mobileChart", "green", "Total Mobile Views", $scope.currentDrawing);

                if ($scope.currentPage == "/")
                    $scope.currentPage = "Main Page";
            };

            $scope.draw = function (type) {

                if ($scope.currentPage == "Main Page")
                    $scope.currentPage = "/";

                $scope.currentType = type;

                $scope.reorganize($scope.currentPage, "desktop", $scope.currentDrawing);
                $scope.forecast($scope.currentType, $scope.currentDrawing);

                if ($scope.currentDrawing == "comparison")
                    $scope.error("desktop");

                $scope.graph("#desktopChart", "blue", "Total Desktop Views", $scope.currentDrawing);

                $scope.reorganize($scope.currentPage, "mobile", $scope.currentDrawing);
                $scope.forecast($scope.currentType, $scope.currentDrawing);

                if ($scope.currentDrawing == "comparison")
                    $scope.error("mobile");

                $scope.graph("#mobileChart", "green", "Total Mobile Views", $scope.currentDrawing);

                if ($scope.currentPage == "/")
                    $scope.currentPage = "Main Page";

            };

            $scope.reorganize = function (page, device, draw) {

                data = [], data2 = [];
                curve = [], curve2 = [];

                var month = 0, year = 2014, count = 0;

                var dic = {};

                if (draw == "comparison") {

                    for (var i = 0; i < sessions.length; i++) {

                        year = parseInt(sessions[i][2]);
                        month = parseInt(sessions[i][3]);
                        count = parseInt(sessions[i][4]);

                        if (sessions[i][0] == page && sessions[i][1] == device && year == 2014) {

                            if (dic[month] == null)
                                dic[month] = 0;

                            dic[month] += count;

                        }

                    }

                    for (var key in dic) {
                        data.push([parseInt(key), dic[key]]);
                    }

                    dic = [];

                    for (var i = 0; i < sessions.length; i++) {

                        year = parseInt(sessions[i][2]);
                        month = parseInt(sessions[i][3]);
                        count = parseInt(sessions[i][4]);

                        if (sessions[i][0] == page && sessions[i][1] == device && year == 2015) {

                            month += 12;

                            if (dic[month] == null)
                                dic[month] = 0;

                            dic[month] += count;

                        }

                    }

                    for (var key in dic) {
                        data2.push([parseInt(key), dic[key]]);
                    }

                } else {

                    for (var i = 0; i < sessions.length; i++) {

                        year = parseInt(sessions[i][2]);
                        month = parseInt(sessions[i][3]);
                        count = parseInt(sessions[i][4]);

                        if (sessions[i][0] == page && sessions[i][1] == device && year == 2015) {

                            if (dic[month] == null)
                                dic[month] = 0;

                            dic[month] += count;

                        }

                    }

                    for (var key in dic) {
                        data.push([parseInt(key), dic[key]]);
                    }
                }

            };

            $scope.forecast = function (type, draw) {

                var rawData = [];

                for (var i = 0; i < data.length; i++) {
                    rawData.push(data[i]);
                }

                if (type == "linear")
                    $scope.linearRegression(rawData, draw);
                else if (type == "iterativeLinear")
                    $scope.iterativeLinearRegression(rawData, draw);
                else if (type == "polynomial4")
                    $scope.polynomialRegression(rawData, 4, draw);
                else if (type == "polynomial6")
                    $scope.polynomialRegression(rawData, 6, draw);
                else if (type == "polynomial8")
                    $scope.polynomialRegression(rawData, 8, draw);
                else if (type == "polynomial10")
                    $scope.polynomialRegression(rawData, 10, draw);
                else
                    $scope.regression(type, rawData, draw);

            };

            $scope.linearRegression = function (feed, draw) {

                var X, Y, Z, inv_Z, sudo_inv_X, W;

                var x = [];
                var y = [];

                for (var i = 0; i < feed.length; i++) {

                    x.push([feed[i][0]]);
                    y.push([feed[i][1]]);

                }

                X = math.matrix(x);
                Y = math.matrix(y);

                Z = math.multiply(math.transpose(X), X);

                inv_Z = math.inv(Z);

                sudo_inv_X = math.multiply(inv_Z, math.transpose(X));

                W = math.multiply(sudo_inv_X, Y);

                var push = [];

                if (draw == "fit") {

                    for (var i = 1; i <= 12; i++) {

                        push = [i, ((-1) * W.get([0, 0]) * i + Y.get([0, 0]))];

                        curve.push(push);

                    }

                } else if (draw == "projection") {

                    var linkageX = data[data.length - 1][0];
                    var linkageY = data[data.length - 1][1];

                    for (var i = 1; i <= 11; i++) {

                        push = [linkageX + i, ((-1) * W.get([0, 0]) * ((linkageX + i) % 12 + 1)) + Y.get([0, 0])];

                        curve.push(push);

                    }

                } else {

                    for (var i = 1; i <= 12; i++) {

                        push = [i, ((-1) * W.get([0, 0]) * i + Y.get([0, 0]))];

                        curve.push(push);

                    }

                    for (var i = 0; i < curve.length ; i++) {

                        curve2.push([curve[i][0] + 12, curve[i][1]]);

                    }

                }

            };

            $scope.linearRegressionWithComponents = function (feed) {

                var X, Y, Z, inv_Z, sudo_inv_X, W;

                var x = [];
                var y = [];

                for (var i = 0; i < feed.length; i++) {

                    x.push([feed[i][0]]);
                    y.push([feed[i][1]]);

                }

                X = math.matrix(x);
                Y = math.matrix(y);

                Z = math.multiply(math.transpose(X), X);

                inv_Z = math.inv(Z);

                sudo_inv_X = math.multiply(inv_Z, math.transpose(X));

                W = math.multiply(sudo_inv_X, Y);

                return { W: W, X: X, Y: Y };

            };

            $scope.iterativeLinearRegression = function (feed, draw) {

                var rawData = [];

                for (var i = 0; i < data.length; i++) {
                    rawData.push(data[i]);
                }

                var result;

                var push = [];

                if (draw == "fit") {

                    for (var i = 1; i <= 12; i++) {

                        result = $scope.linearRegressionWithComponents(rawData);
                        W = regression.W;
                        Y = regression.Y;

                        push = [i, ((-1) * result.W.get([0, 0]) * i) + result.Y.get([0, 0])];

                        curve.push(push);
                        rawData.push(push);

                    }

                } else if (draw == "projection") {

                    var linkageX = data[data.length - 1][0];
                    var linkageY = data[data.length - 1][1];

                    for (var i = 1; i <= 11; i++) {

                        result = $scope.linearRegressionWithComponents(rawData);
                        W = regression.W;
                        Y = regression.Y;

                        push = [linkageX + i, ((-1) * result.W.get([0, 0]) * ((linkageX + i) % 12 + 1)) + result.Y.get([0, 0])];

                        curve.push(push);
                        rawData.push(push);

                    }

                } else {

                    for (var i = 1; i <= 12; i++) {

                        result = $scope.linearRegressionWithComponents(rawData);
                        W = regression.W;
                        Y = regression.Y;

                        push = [i, ((-1) * result.W.get([0, 0]) * i) + result.Y.get([0, 0])];

                        curve.push(push);
                        rawData.push(push);

                    }

                    var linkageX = data[data.length - 1][0];
                    var linkageY = data[data.length - 1][1];

                    for (var i = 1; i <= 11; i++) {

                        result = $scope.linearRegressionWithComponents(rawData);
                        W = regression.W;
                        Y = regression.Y;

                        push = [linkageX + i, ((-1) * result.W.get([0, 0]) * ((linkageX + i) % 12 + 1)) + result.Y.get([0, 0])];

                        curve2.push(push);
                        rawData.push(push);

                    }

                }

            };

            $scope.polynomialRegression = function (feed, fit, draw) {

                var result = regression('polynomial', feed, fit);

                if (draw == "fit") {

                    curve = result.points;

                }
                else if (draw == "projection") {

                    for (var i = 0; i < result.points.length; i++) {

                        result.points[i][0] += 12;

                    }

                    curve = result.points;

                } else if (draw == "comparison") {

                    curve = result.points;

                    for (var i = 0; i < curve.length ; i++) {

                        curve2.push([curve[i][0] + 12, curve[i][1]]);

                    }

                }

            };

            $scope.regression = function (type, feed, draw) {

                var result = regression(type, feed);

                if (draw == "fit") {

                    curve = result.points;

                }
                else if (draw == "projection") {

                    for (var i = 0; i < result.points.length; i++) {

                        result.points[i][0] += 12;

                    }

                    curve = result.points;

                } else if (draw == "comparison") {

                    curve = result.points;

                    for (var i = 0; i < curve.length ; i++) {

                        curve2.push([curve[i][0] + 12, curve[i][1]]);

                    }

                }

            };

            $scope.graph = function (id, color, caption, draw) {

                var appendix = 1;

                if (draw == "projection" || draw == "comparison") {
                    appendix = 13;
                }

                var graph = [
                    { label: caption, data: data, color: App.getLayoutColorCode(color) },
                    { label: "Curve", data: curve, color: App.getLayoutColorCode("red") }
                ];

                if (data2 != null)
                    graph.push({ data: data2, color: App.getLayoutColorCode(color) });

                if (curve2 != null)
                    graph.push({ data: curve2, color: App.getLayoutColorCode("red") });

                $.plot(id, graph, $.extend(true, {}, Plugins.getFlotDefaults(), {
                    xaxis: {
                        min: 0,
                        max: 12 + appendix,
                        tickSize: 1,
                        ticks: [
                            [-11, "Jan"], [-10, "Feb"], [-9, "Mar"], [-8, "Apr"], [-7, "May"], [-6, "Jun"], [-5, "Jul"], [-4, "Aug"], [-3, "Sep"], [-2, "Oct"], [-1, "Nov"], [0, "Dec"],
                            [1, "Jan"], [2, "Feb"], [3, "Mar"], [4, "Apr"], [5, "May"], [6, "Jun"], [7, "Jul"], [8, "Aug"], [9, "Sep"], [10, "Oct"], [11, "Nov"], [12, "Dec"],
                            [13, "Jan"], [14, "Feb"], [15, "Mar"], [16, "Apr"], [17, "May"], [18, "Jun"], [19, "Jul"], [20, "Aug"], [21, "Sep"], [22, "Oct"], [23, "Nov"], [24, "Dec"]
                        ]
                    },
                    series: {
                        lines: {
                            fill: false,
                            lineWidth: 1
                        },
                        points: {
                            show: true,
                            radius: 2.5,
                            lineWidth: 1
                        },
                        grow: { active: true, growings: [{ stepMode: "maximum" }] }
                    },
                    grid: {
                        hoverable: true,
                        clickable: true
                    },
                    tooltip: true,
                    tooltipOpts: {
                        content: '%s: %y'
                    }
                }));

            };

            $scope.error = function (device) {

                var errors = [];

                var error = 0;

                for (var i = 0; i < curve2.length; i++) {

                    error = curve2[i][1] - data2[i][1];
                    error /= data2[i][1];                    

                    errors.push(error);

                }

                var sum = 0;

                for (var i = 0; i < errors.length; i++) {

                    sum += errors[i];

                }
                              
                sum = Math.abs(sum);

                if (device == "desktop")
                    $scope.desktopError = "Error Score: " + sum.toString().split('.')[0];
                else
                    $scope.mobileError = "Error Score: " + sum.toString().split('.')[0];

            };

            $scope.start();

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

    <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/mathjs/3.2.1/math.min.js"></script>

</head>
<body ng-app="fc" ng-controller="Ctrl" id="body">

    <header class="header navbar navbar-fixed-top" role="banner">

        <div class="container">
            <ul class="nav navbar-nav">
                <li class="nav-toggle"><a href="javascript:void(0);" title=""><i class="icon-reorder"></i></a></li>
            </ul>

            <a class="navbar-brand" href="index.html">
                <img src="/Template/assets/img/logo.png" alt="logo" />
                <strong>CastAnalysis</strong>
            </a>

            <ul class="nav navbar-nav navbar-left hidden-xs hidden-sm">
                <li>
                    <a href="/Page/Account/<%: ViewBag.AccountID %>">
                        <i class="fa fa-database"></i>
                        Current Data
                    </a>
                </li>
                <li>
                    <a href="/Page/Analysis/<%: ViewBag.AccountID %>">
                        <i class="fa fa-line-chart"></i>
                        Future Analysis
                    </a>
                </li>
            </ul>

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
                        <span class="username"><%: ViewBag.User.Name %></span>
                        <i class="icon-caret-down small"></i>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="#" ng-click="logout()"><i class="icon-key"></i>Log Out</a></li>
                    </ul>
                </li>
            </ul>
        </div>

        <div id="project-switcher" class="container project-switcher">
            <div id="scrollbar">
                <div class="handle"></div>
            </div>

            <div id="frame">
                <ul class="project-list">
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

    <div id="container">

        <div id="sidebar" class="sidebar-fixed">
            <div id="sidebar-content">

                <!--=== Navigation ===-->
                <ul id="nav">
                    <li ng-repeat="page in pages">
                        <a href="#">
                            <i class="icon-globe"></i>{{page}}</a>
                        <ul class="sub-menu">
                            <li>
                                <a href="#" ng-click="project(page,'fit')">
                                    <i class="icon-angle-right"></i>
                                    Last Year's Curve                                    
                                </a>
                            </li>
                            <li>
                                <a href="#" ng-click="project(page,'projection')">
                                    <i class="icon-angle-right"></i>
                                    Next Year's Projection
                                </a>
                            </li>
                            <li>
                                <a href="#" ng-click="project(page,'comparison')">
                                    <i class="icon-angle-right"></i>
                                    Last 2 Year's Comparison
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>

            </div>
            <div id="divider" class="resizeable"></div>
        </div>

        <div id="content">

            <div class="container">

                <div class="crumbs">
                    <ul id="breadcrumbs" class="breadcrumb">
                        <li>
                            <i class="icon-home"></i>
                            <a href="#">Future Analysis</a>
                        </li>
                        <li class="current">
                            <a href="#" title="">{{currentPage}}</a>
                        </li>
                    </ul>

                    <ul class="crumb-buttons">
                        <li class="dropdown">
                            <a href="#" title="" data-toggle="dropdown"><span>Regression Methods</span><i class="icon-angle-down left-padding"></i></a>
                            <ul class="dropdown-menu pull-right">
                                <li><a href="#" ng-click="draw('linear')" title="">Linear Regression</a></li>
                                <li><a href="#" ng-click="draw('iterativeLinear')" title="">Iterative Linear Regression</a></li>
                                <li><a href="#" ng-click="draw('exponential')" title="">Exponential Regression</a></li>
                                <li><a href="#" ng-click="draw('power')" title="">Power Regression</a></li>
                                <li><a href="#" ng-click="draw('logarithmic')" title="">Logarithmic Regression</a></li>
                                <li><a href="#" ng-click="draw('polynomial4')" title="">4th Polynomial Regression</a></li>
                                <li><a href="#" ng-click="draw('polynomial6')" title="">6th Polynomial Regression</a></li>
                                <li><a href="#" ng-click="draw('polynomial8')" title="">8th Polynomial Regression</a></li>
                                <li><a href="#" ng-click="draw('polynomial10')" title="">10th Polynomial Regression</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>

                <div class="row" id="chart1" style="display: none">
                    <div class="col-md-12">
                        <div class="widget box">
                            <div class="widget-header">
                                <h4><i class="icon-desktop"></i>{{header}}</h4>
                                <div class="toolbar no-padding">
                                    <div class="btn-group">
                                        {{desktopError}}
                                    </div>
                                </div>
                            </div>
                            <div class="widget-content">
                                <div id="desktopChart" class="chart"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" id="chart2" style="display: none">
                    <div class="col-md-12">
                        <div class="widget box">
                            <div class="widget-header">
                                <h4><i class="icon-mobile-phone"></i>{{header}}</h4>
                                <div class="toolbar no-padding">
                                    <div class="btn-group">
                                        {{mobileError}}
                                    </div>
                                </div>
                            </div>
                            <div class="widget-content">
                                <div id="mobileChart" class="chart"></div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>

    <script type="text/javascript">

        function init() {

            angular.element(document.getElementById("body")).scope().init();

        }

    </script>

    <script src="https://apis.google.com/js/client.js?onload=init"></script>
</body>
</html>
