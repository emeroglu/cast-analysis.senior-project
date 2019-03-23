<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>CastAnalysis | <%: (ViewBag.User != null)?Html.Raw(ViewBag.Website.Name):"" %></title>

    <link href="/Template/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />

    <!-- jQuery UI -->
    <!--<link href="plugins/jquery-ui/jquery-ui-1.10.2.custom.css" rel="stylesheet" type="text/css" />-->
    <!--[if lt IE 9]>
		<link rel="stylesheet" type="text/css" href="plugins/jquery-ui/jquery.ui.1.10.2.ie.css"/>
	<![endif]-->

    <!-- Theme -->
    <link href="/Template/assets/css/main.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/responsive.css" rel="stylesheet" type="text/css" />
    <link href="/Template/assets/css/icons.css" rel="stylesheet" type="text/css" />

    <link rel="stylesheet" href="/Template/assets/css/fontawesome/font-awesome.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
    <!--[if IE 7]>
		<link rel="stylesheet" href="/Template/assets/css/fontawesome/font-awesome-ie7.min.css">
	<![endif]-->

    <!--[if IE 8]>
		<link href="/Template/assets/css/ie8.css" rel="stylesheet" type="text/css" />
	<![endif]-->
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,600,700' rel='stylesheet' type='text/css'>

    <!--=== JavaScript ===-->

    <script type="text/javascript" src="/Template/assets/js/libs/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/jquery-ui/jquery-ui-1.10.2.custom.min.js"></script>

    <script type="text/javascript" src="/Template/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/Template/assets/js/libs/lodash.compat.min.js"></script>

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
		<script src="/Template/assets/js/libs/html5shiv.js"></script>
	<![endif]-->

    <!-- Smartphone Touch Events -->
    <script type="text/javascript" src="/Template/plugins/touchpunch/jquery.ui.touch-punch.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/event.swipe/jquery.event.move.js"></script>
    <script type="text/javascript" src="/Template/plugins/event.swipe/jquery.event.swipe.js"></script>

    <script src="https://code.angularjs.org/1.5.0-rc.2/angular.js"></script>

    <script type="text/javascript">

        var appReady = false;

        angular.module('fc', [])

        .controller("Ctrl", function ($scope, $http) {

            $http.get("/Service/AllWebsites").success(function (data) {

                $scope.websites = data;

                $http.get("/Service/AllWebpages/<%: (ViewBag.Website != null) ? ViewBag.Website.PK : "" %>").success(function (data) {

                    $scope.webpages = data;

                    var count = $scope.webpages.length;

                    $scope.indexes = [];

                    for (var i = 0; i < count / 2; i++) {

                        $scope.indexes.push(i * 2);

                    }                   

                    appReady = true;

                });

            });

            $scope.logout = function () {

                $http.get("/Service/LogTheUserOut/<%: (ViewBag.User != null)?Html.Raw(ViewBag.User.PK):"" %>").success(function (data) {

                    location.href = "/Page/Login";

                });

            };

        });

    </script>

    <!-- General -->
    <script type="text/javascript" src="/Template/assets/js/libs/breakpoints.js"></script>
    <script type="text/javascript" src="/Template/plugins/respond/respond.min.js"></script>
    <!-- Polyfill for min/max-width CSS3 Media Queries (only for IE8) -->
    <script type="text/javascript" src="/Template/plugins/cookie/jquery.cookie.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/slimscroll/jquery.slimscroll.horizontal.min.js"></script>

    <!-- Page specific plugins -->
    <!-- Charts -->
    <!--[if lt IE 9]>
		<script type="text/javascript" src="plugins/flot/excanvas.min.js"></script>
	<![endif]-->
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

    <!-- Noty -->
    <script type="text/javascript" src="/Template/plugins/noty/jquery.noty.js"></script>
    <script type="text/javascript" src="/Template/plugins/noty/layouts/top.js"></script>
    <script type="text/javascript" src="/Template/plugins/noty/themes/default.js"></script>

    <!-- Forms -->
    <script type="text/javascript" src="/Template/plugins/uniform/jquery.uniform.min.js"></script>
    <script type="text/javascript" src="/Template/plugins/select2/select2.min.js"></script>

    <!-- App -->
    <script type="text/javascript" src="/Template/assets/js/app.js"></script>
    <script type="text/javascript" src="/Template/assets/js/plugins.js"></script>
    <script type="text/javascript" src="/Template/assets/js/plugins.form-components.js"></script>

    <script>

        Start();

        function Start() {

            if (appReady) {
                App.init(); // Init layout and core plugins
                Plugins.init(); // Init all plugins
                FormComponents.init(); // Init all form-specific plugins
            }
            else {
                setTimeout(function () { Start(); }, 1000);
            }

        }
    </script>

</head>
<body ng-app="fc" ng-controller="Ctrl">
    <header class="header navbar navbar-fixed-top" role="banner">
        <!-- Top Navigation Bar -->
        <div class="container">

            <!-- Only visible on smartphones, menu toggle -->
            <ul class="nav navbar-nav">
                <li class="nav-toggle"><a href="javascript:void(0);" title=""><i class="icon-reorder"></i></a></li>
            </ul>

            <!-- Logo -->
            <a class="navbar-brand" href="index.html">
                <img src="/Template/assets/img/logo.png" alt="logo" />
                <strong><%: (ViewBag.Website != null)?Html.Raw(ViewBag.Website.Name):"" %></strong>
            </a>
            <!-- /logo -->

            <ul class="nav navbar-nav navbar-left hidden-xs hidden-sm">
                <li>
                    <a href="#">
                        <i class="fa fa-database"></i>
                        Current Data
                    </a>
                </li>
                <li>
                    <a href="#">
                        <i class="fa fa-line-chart"></i>
                        Future Analysis
                    </a>
                </li>
            </ul>

            <!-- Top Right Menu -->
            <ul class="nav navbar-nav navbar-right">

                <!-- Project Switcher Button -->
                <li class="dropdown">
                    <a href="#" class="project-switcher-btn dropdown-toggle">
                        <i class="fa fa-globe"></i>
                        <span>Websites</span>
                    </a>
                </li>

                <!-- User Login Dropdown -->
                <li class="dropdown user">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <!--<img alt="" src="/Template/assets/img/avatar1_small.jpg" />-->
                        <i class="icon-male"></i>
                        <span class="username"><%: (ViewBag.User != null)?Html.Raw(ViewBag.User.Username):"" %></span>
                        <i class="icon-caret-down small"></i>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="/Page/Profile/<%: (ViewBag.User != null)?Html.Raw(ViewBag.User.PK):"" %>"><i class="icon-user"></i>Profile</a></li>
                        <li class="divider"></li>
                        <li><a href="#" ng-click="logout()"><i class="icon-key"></i>Log Out</a></li>
                    </ul>
                </li>
                <!-- /user login dropdown -->
            </ul>
            <!-- /Top Right Menu -->
        </div>
        <!-- /top navigation bar -->

        <!--=== Project Switcher ===-->
        <div id="project-switcher" class="container project-switcher">
            <div id="scrollbar">
                <div class="handle"></div>
            </div>

            <div id="frame">
                <ul class="project-list">
                    <li ng-repeat="website in websites">
                        <a href="/Page/Website/<%: (ViewBag.User != null)?Html.Raw(ViewBag.User.PK):"" %>/{{website.pk}}">
                            <span class="image"><i class="icon-male"></i></span>
                            <span class="title">{{website.name}}</span>
                        </a>
                    </li>
                </ul>
            </div>
            <!-- /#frame -->
        </div>
        <!-- /#project-switcher -->
    </header>

    <div id="container" class="fixed-header" style="margin: 60px;margin-top: 75px;">

        <div class="row" ng-repeat="i in indexes">
            <!--=== Simple Table ===-->
            <div class="col-md-6">
                <div class="widget box widget-closed">
                    <div class="widget-header">
                        <h4><i class="fa fa-file-text-o"></i>{{webpages[i].name}}</h4>
                        <div class="toolbar no-padding">
                            <div class="btn-group">
                                <span class="btn btn-xs widget-collapse"><i class="icon-angle-up"></i></span>
                            </div>
                        </div>
                    </div>
                    <div class="widget-content" style="display: none;">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>#</th>                                    
                                    <th>Today's</th>                                    
                                    <th>Today's Mobile</th>
                                    <th>Today's Desktop</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td></td>                                    
                                    <td>{{webpages[i].today}}</td>
                                    <td>{{webpages[i].mobile}}</td>
                                    <td>{{webpages[i].desktop}}</td>
                                </tr>                                
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- /Simple Table -->
            </div>

            <!--=== Striped Table ===-->
            <div class="col-md-6" ng-if="i <= webpages.length - 2">
                <div class="widget box widget-closed">
                    <div class="widget-header">
                        <h4><i class="fa fa-file-text-o"></i>{{webpages[i+1].name}}</h4>
                        <div class="toolbar no-padding">
                            <div class="btn-group">
                                <span class="btn btn-xs widget-collapse"><i class="icon-angle-up"></i></span>
                            </div>
                        </div>
                    </div>
                    <div class="widget-content" style="display: none;">
                        <table class="table table-hover table-striped">
                            <thead>
                                <tr>
                                    <th>#</th>                                    
                                    <th>Today's</th>                                    
                                    <th>Today's Mobile</th>
                                    <th>Today's Desktop</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td></td>                                    
                                    <td>{{webpages[i + 1].today}}</td>
                                    <td>{{webpages[i + 1].mobile}}</td>
                                    <td>{{webpages[i + 1].desktop}}</td>
                                </tr>                                
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- /Striped Table -->
        </div>        

    </div>
</body>
</html>
