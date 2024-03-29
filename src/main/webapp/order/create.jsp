<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Upvex - Responsive Admin Dashboard Template</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="A fully featured admin theme which can be used to build CRM, CMS, etc." name="description">
    <meta content="Coderthemes" name="author">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- App favicon -->
    <link rel="shortcut icon" href="assets/images/favicon.ico">

    <!-- plugin css -->
    <link href="assets/libs/jquery-vectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css">

    <!-- App css -->
    <link href="assets/css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css">
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css">
    <link href="assets/css/css-my-style.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="/assets/iziToast/iziToast-1.4.0.min.css">

</head>

<body>

<!-- Begin page -->
<div id="wrapper">

    <!-- Topbar Start -->
    <jsp:include page="../shared/navbar-custom.jsp"></jsp:include>
    <!-- end Topbar -->

    <!-- ========== Left Sidebar Start ========== -->
    <jsp:include page="../shared/left-side-menu.jsp"></jsp:include>
    <!-- Left Sidebar End -->

    <!-- ============================================================== -->
    <!-- Start Page Content here -->
    <!-- ============================================================== -->

    <div class="content-page">
        <div class="content">

            <!-- Start Content-->
            <div class="container-fluid">

                <!-- start page title -->
                <div class="row">
                    <div class="col-12">
                        <div class="page-title-box">
                            <div class="page-title-right">
                                <ol class="breadcrumb m-0">
                                    <li class="breadcrumb-item"><a href="javascript: void(0);">Upvex</a></li>
                                    <li class="breadcrumb-item"><a href="javascript: void(0);">Dashboards</a></li>
                                    <li class="breadcrumb-item active">Dashboard</li>
                                </ol>
                            </div>
                            <h4 class="page-title">Wel Come Create Order</h4>
                        </div>
                    </div>
                </div>
                <!-- end page title -->

                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <form method="post" enctype="multipart/form-data">
                                    <div class="form-row">
                                        <div class="form-group col-md-6">
                                            <label for="category_id" class="col-form-label">Category</label>
                                            <select id="category_id" class="form-control" name="category_id">
                                                <c:forEach items="${requestScope['categoryList']}" var="item">
                                                    <option value="${item.getId()}">${item.getTitle()}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label for="product_id" class="col-form-label">Product</label>
                                            <select id="product_id" class="form-control" name="product_id">
                                                <c:forEach items="${requestScope['categoryList']}" var="item">
                                                    <option value="${item.getId()}">${item.getTitle()}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-group col-md-6">
                                            <label for="quantity" class="col-form-label">Quantity</label>
                                            <input type="number" value="1" min="1" required class="form-control" id="quantity"  name="quantity" aria-required="true">
                                        </div>
<%--                                        <div class="form-group col-md-6">--%>
<%--                                            <label for="inputPassword4" class="col-form-label">Price</label>--%>
<%--                                            <input type="number"  required class="form-control" id="inputPassword4" placeholder="Price" name="price" min="0" aria-required="true">--%>
<%--                                        </div>--%>
                                    </div>
                                    <button type="button" id="btnAdd" class="btn btn-primary waves-effect waves-light">Add</button>
                                </form>
                                <h6>
                                    <c:if test="${requestScope['success'] == true}">
                                        <c:out value="${'Thêm Sản Phẩm Thành Công'}"></c:out>
                                    </c:if>
                                </h6>
                                <ul>
                                    <c:forEach items="${requestScope['errors']}" var="err">
                                        <li>${err}</li>
                                    </c:forEach>
                                </ul>
                            </div> <!-- end card-body -->
                        </div> <!-- end card-->
                    </div> <!-- end col -->
                </div>

            </div> <!-- container -->

        </div> <!-- content -->

        <jsp:include page="../shared/footer.jsp"></jsp:include>

    </div>

    <!-- ============================================================== -->
    <!-- End Page content -->
    <!-- ============================================================== -->


</div>
<!-- END wrapper -->

<!-- Right Sidebar -->
<jsp:include page="../shared/right-bar.jsp"></jsp:include>
<!-- /Right-bar -->

<!-- Right bar overlay-->
<div class="rightbar-overlay"></div>

<jsp:include page="../shared/script.jsp"></jsp:include>

<script src="/assets/iziToast/iziToast-1.4.0.js"></script>

<script>
    let btnAdd = document.getElementById('btnAdd');
    let categoryId = document.getElementById('category_id');
    let productId = document.getElementById('product_id');
    let quantity = document.getElementById('quantity');

    btnAdd.addEventListener('click', function () {
        addCart(productId.value, quantity.value);
    })

    categoryId.addEventListener('change', function () {
        getAllProductsByCategory(categoryId.value);
    })

    function getAllProductsByCategory(categoryId) {
        fetch('http://localhost:8080/api/products?action=get-all-products&category=' + categoryId)
            .then(response => response.json())
            .then(data => {
                let str = '';

                if (data != null) {
                    data.forEach((item, index) => {
                        str += `<option value="\${item.id}">\${item.title} (\${item.price})</option>`;
                    })
                    productId.innerHTML = str;
                }
                else {
                    productId.innerHTML = '';
                }
            });
    }

    function addCart(productId, quantity) {
        fetch('http://localhost:8080/api/carts?action=add&product_id=' + productId + '&quantity=' + quantity)
            .then(response => response.json())
            .then(data => {

                if (data.success === "true") {
                    iziToast.success({
                        title: 'SUCCESS',
                        position: 'bottomRight',
                        timeout: 2500,
                        message: data.message
                    });
                }
                else {
                    iziToast.error({
                        title: 'ERROR',
                        position: 'bottomRight',
                        timeout: 2500,
                        message: data.message
                    });
                }


            });
    }


</script>

</body>
</html>
