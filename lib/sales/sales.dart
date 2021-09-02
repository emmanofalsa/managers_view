import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:managers_view/address/api.dart';
import 'package:managers_view/address/url.dart';
import 'package:managers_view/global/variables.dart';
import 'package:managers_view/session/session_timer.dart';
import 'package:managers_view/variables/assets.dart';
import 'package:managers_view/variables/colors.dart';

class Sales extends StatefulWidget {
  @override
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  var colorCode = '';
  String startdate = "";
  String enddate = "";
  String weekstart = "";
  String weekend = "";
  double categHeight = 0.00;

  // List<bool> _isOpen;
  bool _expandedSalesman = false;
  bool _expandedCustomer = false;
  bool _expandedItems = false;
  List _sList = [];
  List _salesList = [];
  List _wsalesList = [];
  List _msalesList = [];
  List _ysalesList = [];
  // List _smList = [];
  List _smsalelist = [];
  List _totlist = [];
  List _smtypelist = [];
  List _custtypelist = [];
  List _itmtypelist = [];
  List _custsalelist = [];
  List _itemsalelist = [];
  List _custDsalesList = [];
  List _custWsalesList = [];
  List _custMsalesList = [];
  List _custYsalesList = [];
  List _itmDsalesList = [];
  List _itmWsalesList = [];
  List _itmMsalesList = [];
  List _itmYsalesList = [];

  bool viewSpinkit = true;
  bool noImage = true;
  bool noSM = true;

  final formatCurrencyAmt =
      new NumberFormat.currency(locale: "en_US", symbol: "P");
  final formatCurrencyTot =
      new NumberFormat.currency(locale: "en_US", symbol: "Php ");

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  final String today =
      DateFormat("EEEE, MMM-dd-yyyy").format(new DateTime.now());
  final date =
      DateTime.parse(DateFormat("yyyy-mm-dd").format(new DateTime.now()));

  final String month = DateFormat("MMMM yyyy").format(new DateTime.now());
  final String year = DateFormat("yyyy").format(new DateTime.now());

  void initState() {
    super.initState();
    loadSales();
  }

  loadSales() async {
    loadSalesType();
    //SALESMAN
    loadSalesmanDailySales();
    loadSalesmanWeeklySales();
    loadSalesmanMonthlySales();
    loadSalesmanYearlySales();
    //CUSTOMER
    loadCustomerDailySales();
    loadCustomerWeeklySales();
    loadCustomerMonthlySales();
    loadCustomerYearlysales();
    //ITEMS
    loadItemDailySales();
    loadItemWeeklySales();
    loadItemMonthlySales();
    loadItemYearlySales();
  }

  loadCustomerYearlysales() async {
    _custYsalesList.clear();
    _sList.clear();

    var getDsales =
        await getCustomerYearlySales(SalesData.overallSalesType.toUpperCase());

    _sList = getDsales;
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _custYsalesList.add(element);
      });
    });
    viewSpinkit = false;
  }

  loadCustomerMonthlySales() async {
    _custMsalesList.clear();
    _sList.clear();
    var getDsales =
        await getCustomerMonthlySales(SalesData.overallSalesType.toUpperCase());
    _sList = getDsales;
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _custMsalesList.add(element);
      });
    });
    viewSpinkit = false;
  }

  loadCustomerWeeklySales() async {
    _custWsalesList.clear();
    _sList.clear();

    var getDsales =
        await getCustomerWeeklySales(SalesData.overallSalesType.toUpperCase());

    _sList = getDsales;
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _custWsalesList.add(element);
      });

      startdate = element['week_start'];
      enddate = element['week_end'];
      DateTime s = DateTime.parse(startdate);
      DateTime e = DateTime.parse(enddate);
      weekstart = DateFormat("MMM dd ").format(s);
      weekend = DateFormat("MMM dd yyyy ").format(e);
    });

    viewSpinkit = false;
  }

  loadCustomerDailySales() async {
    _custDsalesList.clear();
    _sList.clear();
    var getDsales =
        await getCustomerDailySales(SalesData.overallSalesType.toUpperCase());
    _sList = getDsales;
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _custDsalesList.add(element);
      });
    });
    customerSalesTypeChanged();
    viewSpinkit = false;
  }

  loadSalesmanYearlySales() async {
    SalesData.salesYearly = '0.00';
    _ysalesList.clear();
    double totalSales = 0.00;
    _sList.clear();
    var getDsales =
        await getYearlySales(SalesData.overallSalesType.toUpperCase());
    _sList = getDsales;
    _sList.forEach((element) {
      totalSales = totalSales + double.parse(element['total']);
      _ysalesList.add(element);
    });
    SalesData.salesYearly = totalSales.toStringAsFixed(2);
    viewSpinkit = false;
  }

  loadSalesmanMonthlySales() async {
    SalesData.salesMonthly = '0.00';
    _msalesList.clear();
    double totalSales = 0.00;
    _sList.clear();
    var getDsales =
        await getMonthlySales(SalesData.overallSalesType.toUpperCase());
    _sList = getDsales;
    _sList.forEach((element) {
      totalSales = totalSales + double.parse(element['total']);
      _msalesList.add(element);
    });
    SalesData.salesMonthly = totalSales.toStringAsFixed(2);

    viewSpinkit = false;
  }

  loadSalesmanWeeklySales() async {
    SalesData.salesWeekly = '0.00';
    _wsalesList.clear();
    double totalSales = 0.00;
    _sList.clear();
    var getDsales =
        await getWeeklySales(SalesData.overallSalesType.toUpperCase());
    _sList = getDsales;
    print(_sList);
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        totalSales = totalSales + double.parse(element['total']);
        _wsalesList.add(element);
      });
    });
    SalesData.salesWeekly = totalSales.toStringAsFixed(2);
    viewSpinkit = false;
  }

  loadSalesmanDailySales() async {
    SalesData.salesToday = '0.00';
    double totalSales = 0.00;
    _salesList.clear();
    _sList.clear();
    var getDsales =
        await getDailySales(SalesData.overallSalesType.toUpperCase());
    _sList = getDsales;
    print(_sList);
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        totalSales = totalSales + double.parse(element['total']);
        _salesList.add(element);
      });
    });
    SalesData.salesToday = totalSales.toStringAsFixed(2);
    viewSpinkit = false;
    salesmanSalesTypeChanged();
  }

  loadSalesType() async {
    SalesData.overallSalesType = 'Overall';
    SalesData.smTotalCaption = 'Sales';
    SalesData.custTotalCaption = 'Total Amount';
    SalesData.itmTotalCaption = 'Total Qty';
    _smtypelist.clear();
    _custtypelist.clear();
    _itmtypelist.clear();
    _totlist.clear();
    var getU = await getSalesType();
    if (!mounted) return;
    setState(() {
      _smtypelist = getU;
      _custtypelist = getU;
      _itmtypelist = getU;
      SalesData.salesmanSalesType = 'Today';
      SalesData.customerSalesType = 'Today';
      SalesData.itemSalesType = 'Today';
    });
    var getT = await getTotalSalesType();
    if (!mounted) return;
    setState(() {
      _totlist = getT;
      SalesData.overallSalesType = 'Overall';
    });
  }

  loadItemDailySales() async {
    _itmDsalesList.clear();
    _sList.clear();
    var getDsales = await getItemDailySales();
    _sList = getDsales;
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _itmDsalesList.add(element);
      });
    });
    itemSalesTypeChanged();
    viewSpinkit = false;
  }

  loadItemWeeklySales() async {
    _itmWsalesList.clear();
    _sList.clear();
    var getWsales = await getItemWeeklySales();
    _sList = getWsales;
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _itmWsalesList.add(element);
      });
    });
    // print(_itmWsalesList);
    itemSalesTypeChanged();
    viewSpinkit = false;
  }

  loadItemMonthlySales() async {
    _itmMsalesList.clear();
    _sList.clear();
    var getMsales = await getItemMonthlySales();
    _sList = getMsales;
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _itmMsalesList.add(element);
      });
    });
    // print(_itmMsalesList);
    itemSalesTypeChanged();
    viewSpinkit = false;
  }

  loadItemYearlySales() async {
    _itmYsalesList.clear();
    _sList.clear();
    var getYsales = await getItemYearlySales();
    _sList = getYsales;
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _itmYsalesList.add(element);
      });
    });
    // print(_itmYsalesList);
    itemSalesTypeChanged();
    viewSpinkit = false;
  }

  overAllSalesTypeChanged() {
    if (SalesData.overallSalesType == 'Overall') {
      setState(() {
        _smsalelist.clear();
        _custsalelist.clear();
        _itemsalelist.clear();
        SalesData.smTotalCaption = 'Sales';
        SalesData.custTotalCaption = 'Total Amount';
        SalesData.salesmanSalesType = 'Today';
        SalesData.customerSalesType = 'Today';
        SalesData.itemSalesType = 'Today';
        loadSalesmanDailySales();
        loadSalesmanWeeklySales();
        loadSalesmanMonthlySales();
        loadSalesmanYearlySales();
        //CUSTOMER
        loadCustomerDailySales();
        loadCustomerWeeklySales();
        loadCustomerMonthlySales();
        loadCustomerYearlysales();
        //ITEM
        loadItemDailySales();
        loadItemWeeklySales();
        loadItemMonthlySales();
        loadItemYearlySales();
      });
    }
    if (SalesData.overallSalesType == 'Cash') {
      setState(() {
        _smsalelist.clear();
        _custsalelist.clear();
        _itemsalelist.clear();
        SalesData.smTotalCaption = 'Cash Total';
        SalesData.custTotalCaption = 'Cash Total';
        SalesData.salesmanSalesType = 'Today';
        SalesData.customerSalesType = 'Today';
        SalesData.itemSalesType = 'Today';
        loadSalesmanDailySales();
        loadSalesmanWeeklySales();
        loadSalesmanMonthlySales();
        loadSalesmanYearlySales();
        //FOR CUSTOMER
        loadCustomerDailySales();
        loadCustomerWeeklySales();
        loadCustomerMonthlySales();
        loadCustomerYearlysales();
        //ITEM
        loadItemDailySales();
        loadItemWeeklySales();
        loadItemMonthlySales();
        loadItemYearlySales();
      });
    }
    if (SalesData.overallSalesType == 'Cheque') {
      setState(() {
        _smsalelist.clear();
        _custsalelist.clear();
        _itemsalelist.clear();
        SalesData.smTotalCaption = 'Cheque Total';
        SalesData.custTotalCaption = 'Cheque Total';
        SalesData.salesmanSalesType = 'Today';
        SalesData.customerSalesType = 'Today';
        SalesData.itemSalesType = 'Today';
        loadSalesmanDailySales();
        loadSalesmanWeeklySales();
        loadSalesmanMonthlySales();
        loadSalesmanYearlySales();
        //FOR CUSTOMER
        loadCustomerDailySales();
        loadCustomerWeeklySales();
        loadCustomerMonthlySales();
        loadCustomerYearlysales();
        //ITEM
        loadItemDailySales();
        loadItemWeeklySales();
        loadItemMonthlySales();
        loadItemYearlySales();
      });
    }
  }

  customerSalesTypeChanged() {
    if (SalesData.customerSalesType == 'Today') {
      _custsalelist.clear();
      List<double> nums = [];
      _custDsalesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total']));
        });
      });

      nums.sort((b, a) => a.compareTo(b));
      nums.forEach((element) {
        setState(() {
          double amt = element;
          _custDsalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'])) {
                _custsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.customerSalesType == 'Week') {
      _custsalelist.clear();
      List<double> nums = [];
      _custWsalesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total']));
        });
      });
      nums.sort((b, a) => a.compareTo(b));
      nums.forEach((element) {
        setState(() {
          double amt = element;
          _custWsalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'])) {
                _custsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.customerSalesType == 'Month') {
      _custsalelist.clear();
      List<double> nums = [];
      _custMsalesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total']));
        });
      });
      nums.sort((b, a) => a.compareTo(b));
      // print(nums);
      nums.forEach((element) {
        setState(() {
          double amt = element;
          // print(amt);
          _custMsalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'])) {
                _custsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.customerSalesType == 'Year') {
      _custsalelist.clear();
      List<double> nums = [];
      _custYsalesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total']));
        });
      });
      nums.sort((b, a) => a.compareTo(b));
      // print(nums);
      nums.forEach((element) {
        setState(() {
          double amt = element;
          // print(amt);
          _custYsalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'])) {
                _custsalelist.add(element);
              }
            });
          });
        });
      });
    }
  }

  salesmanSalesTypeChanged() {
    if (SalesData.salesmanSalesType == 'Today') {
      _smsalelist.clear();
      List<double> nums = [];
      _salesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total']));
        });
      });
      nums.sort((b, a) => a.compareTo(b));
      // print(nums);
      nums.forEach((element) {
        setState(() {
          double amt = element;
          // print(amt);
          _salesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'])) {
                _smsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.salesmanSalesType == 'Week') {
      _smsalelist.clear();
      List<double> nums = [];
      _wsalesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total']));
        });
      });
      nums.sort((b, a) => a.compareTo(b));
      // print(nums);
      nums.forEach((element) {
        setState(() {
          double amt = element;
          // print(amt);
          _wsalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'])) {
                _smsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.salesmanSalesType == 'Month') {
      _smsalelist.clear();
      List<double> nums = [];
      _msalesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total']));
        });
      });
      nums.sort((b, a) => a.compareTo(b));
      // print(nums);
      nums.forEach((element) {
        setState(() {
          double amt = element;
          // print(amt);
          _msalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'])) {
                _smsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.salesmanSalesType == 'Year') {
      _smsalelist.clear();
      List<double> nums = [];
      _ysalesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total']));
        });
      });
      nums.sort((b, a) => a.compareTo(b));
      // print(nums);
      nums.forEach((element) {
        setState(() {
          double amt = element;
          // print(amt);
          _ysalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'])) {
                _smsalelist.add(element);
              }
            });
          });
        });
      });
    }
  }

  itemSalesTypeChanged() {
    if (SalesData.itemSalesType == 'Today') {
      _itemsalelist.clear();
      List nums = [];
      _itmDsalesList.forEach((element) {
        setState(() {
          nums.add(element);
        });
      });

      nums.sort(
          (b, a) => int.parse(a['total']).compareTo(int.parse(b['total'])));
      nums.forEach((element) {
        setState(() {
          String desc = element['item_desc'];
          _itmDsalesList.forEach((element) {
            setState(() {
              if (desc == (element['item_desc'])) {
                _itemsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.itemSalesType == 'Week') {
      _itemsalelist.clear();
      List nums = [];
      _itmWsalesList.forEach((element) {
        setState(() {
          nums.add(element);
        });
      });
      // nums.sort((b, a) => a['total'].compareTo(b['total']));
      nums.sort(
          (b, a) => int.parse(a['total']).compareTo(int.parse(b['total'])));
      nums.forEach((element) {
        setState(() {
          String desc = element['item_desc'];
          _itmWsalesList.forEach((element) {
            setState(() {
              if (desc == (element['item_desc'])) {
                _itemsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.itemSalesType == 'Month') {
      _itemsalelist.clear();
      List nums = [];
      _itmMsalesList.forEach((element) {
        setState(() {
          nums.add(element);
        });
      });
      // nums.sort((b, a) => a['total'].compareTo(b['total']));
      nums.sort(
          (b, a) => int.parse(a['total']).compareTo(int.parse(b['total'])));
      nums.forEach((element) {
        setState(() {
          String desc = element['item_desc'];
          _itmMsalesList.forEach((element) {
            setState(() {
              if (desc == (element['item_desc'])) {
                _itemsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.itemSalesType == 'Year') {
      _itemsalelist.clear();
      List nums = [];
      _itmYsalesList.forEach((element) {
        setState(() {
          nums.add(element);
        });
      });
      // nums.sort((b, a) => a['total'].compareTo(b['total']));
      nums.sort(
          (b, a) => int.parse(a['total']).compareTo(int.parse(b['total'])));
      nums.forEach((element) {
        setState(() {
          String desc = element['item_desc'];
          _itmYsalesList.forEach((element) {
            setState(() {
              if (desc == (element['item_desc'])) {
                _itemsalelist.add(element);
              }
            });
          });
        });
      });
    }
  }

  void handleUserInteraction([_]) {
    SessionTimer sessionTimer = SessionTimer();
    sessionTimer.initializeTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        handleUserInteraction();
      },
      onPanDown: (details) {
        handleUserInteraction();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sales",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: ColorsTheme.mainColor,
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
              ),
              // SizedBox(height: 50),
            ],
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildSalesCont(),
                        SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              ExpansionPanelList(
                                expandedHeaderPadding: EdgeInsets.all(1),
                                animationDuration: Duration(milliseconds: 300),
                                expansionCallback: (int i, bool isExpanded) {
                                  _expandedSalesman = !_expandedSalesman;
                                  setState(() {});
                                },
                                children: [
                                  ExpansionPanel(
                                    canTapOnHeader: true,
                                    backgroundColor: Colors.grey[100],
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title: Row(
                                          children: [
                                            Icon(Icons.local_shipping),
                                            SizedBox(width: 10),
                                            Text(
                                              'Salesman',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        horizontalTitleGap: 5,
                                        // contentPadding: EdgeInsets.all(5),
                                      );
                                    },
                                    body: Column(
                                      children: [
                                        buildSalesmanCont(),
                                      ],
                                    ),
                                    isExpanded: _expandedSalesman,
                                  ),
                                ],
                              ),
                              ExpansionPanelList(
                                expandedHeaderPadding: EdgeInsets.all(1),
                                animationDuration: Duration(milliseconds: 300),
                                expansionCallback: (int i, bool isExpanded) {
                                  _expandedCustomer = !_expandedCustomer;
                                  setState(() {});
                                },
                                children: [
                                  ExpansionPanel(
                                    canTapOnHeader: true,
                                    backgroundColor: Colors.deepOrange[100],
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title: Row(
                                          children: [
                                            Icon(Icons.groups),
                                            SizedBox(width: 10),
                                            Text(
                                              'Customer',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    body: Column(
                                      children: [
                                        buildCustomerCont(),
                                      ],
                                    ),
                                    isExpanded: _expandedCustomer,
                                  ),
                                ],
                              ),
                              ExpansionPanelList(
                                expandedHeaderPadding: EdgeInsets.all(1),
                                animationDuration: Duration(milliseconds: 300),
                                expansionCallback: (int i, bool isExpanded) {
                                  _expandedItems = !_expandedItems;
                                  setState(() {});
                                },
                                children: [
                                  ExpansionPanel(
                                    canTapOnHeader: true,
                                    backgroundColor: Colors.blue[100],
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title: Row(
                                          children: [
                                            Icon(Icons.shopping_basket),
                                            SizedBox(width: 10),
                                            Text(
                                              'Items',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    body: Column(
                                      children: [
                                        buildItemCont(),
                                      ],
                                    ),
                                    isExpanded: _expandedItems,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Column(
                        //   children: [
                        //     buildSalesmanCont(),
                        //     SizedBox(
                        //       height: 10,
                        //     ),
                        //     buildCustomerCont(),
                        //     SizedBox(
                        //       height: 10,
                        //     ),
                        //     buildItemCont(),
                        //   ],
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildSalesCont() {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      // width: MediaQuery.of(context).size.width - 40,
                      height: 30,
                      // color: Colors.grey,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: SalesData.overallSalesType,
                            items: _totlist?.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(
                                      item['type'],
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    value: item['type'].toString(),
                                  );
                                })?.toList() ??
                                [],
                            onChanged: (String newV) {
                              setState(() {
                                SalesData.overallSalesType = newV;
                                overAllSalesTypeChanged();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        // color: Colors.grey,
                        child: Stack(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      30,
                                  decoration: BoxDecoration(
                                      color: Colors.orange[300],
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: Text(
                                              'Today',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                30,
                                            // color: Colors.grey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  formatCurrencyAmt
                                                      .format(double.parse(
                                                          SalesData.salesToday))
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: Text(
                                              today,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      30,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[300],
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: Text(
                                              'Week',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                30,
                                            // color: Colors.grey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  formatCurrencyAmt
                                                      .format(double.parse(
                                                          SalesData
                                                              .salesWeekly))
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: Text(
                                              weekstart + '-' + weekend,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        // color: Colors.grey,
                        child: Stack(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      30,
                                  decoration: BoxDecoration(
                                      color: Colors.green[300],
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: Text(
                                              'Month',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                30,
                                            // color: Colors.grey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  formatCurrencyAmt
                                                      .format(double.parse(
                                                          SalesData
                                                              .salesMonthly))
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: Text(
                                              month,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      30,
                                  decoration: BoxDecoration(
                                      color: Colors.purple[300],
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: Text(
                                              'Year',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                30,
                                            // color: Colors.grey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  formatCurrencyAmt
                                                      .format(double.parse(
                                                          SalesData
                                                              .salesYearly))
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: Text(
                                              year,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildSalesmanCont() {
    if (viewSpinkit == true) {
      return Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        // color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                // color: Colors.white,
                height: 100,
                child: Image(
                  color: ColorsTheme.mainColor,
                  image: AssetsValues.spinImg,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      // height: 360,
      // height: MediaQuery.of(context).size.height / 2,
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(0)),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 2,
                      // color: Colors.grey,
                      child: Stack(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 15),
                                child: Container(
                                  child: Text(
                                    'Top Salesman',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 0),
                                // width: MediaQuery.of(context).size.width / 2,
                                // color: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: SalesData.salesmanSalesType,
                                          items: _smtypelist?.map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    item['type'],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  value:
                                                      item['type'].toString(),
                                                );
                                              })?.toList() ??
                                              [],
                                          onChanged: (String newV) {
                                            setState(() {
                                              SalesData.salesmanSalesType =
                                                  newV;
                                              salesmanSalesTypeChanged();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //SALESMAN HEADER NAME ETC
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      width: MediaQuery.of(context).size.width - 2,
                      height: 30,
                      color: Colors.grey[300],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Name',
                              style: TextStyle(),
                            ),
                          ),
                          Container(
                            // width: 50,
                            // color: Colors.blue,
                            child: Text(
                              SalesData.smTotalCaption,
                              style: TextStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 2,
                      // height: MediaQuery.of(context).size.height / 2 - 80,
                      height: MediaQuery.of(context).size.height / 4 - 80,
                      color: Colors.transparent,
                      child: ListView.builder(
                          padding: const EdgeInsets.only(top: 1),
                          itemCount: _smsalelist.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width:
                                        MediaQuery.of(context).size.width - 35,
                                    height: 40,
                                    color: Colors.transparent,
                                    child: Stack(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              _smsalelist[index]['first_name'] +
                                                  ' ' +
                                                  _smsalelist[index]
                                                      ['last_name'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              formatCurrencyAmt.format(
                                                  double.parse(
                                                      _smsalelist[index]
                                                          ['total'])),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildCustomerCont() {
    if (viewSpinkit == true) {
      return Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: SpinKitFadingCircle(
            color: ColorsTheme.mainColor,
            size: 50,
          ),
        ),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.deepOrange[50],
          border: Border.all(color: Colors.deepOrange[50]),
          borderRadius: BorderRadius.circular(0)),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 2,
                      // color: Colors.grey,
                      child: Stack(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 15),
                                child: Container(
                                  child: Text(
                                    'Top Customer',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 0),
                                // width: MediaQuery.of(context).size.width / 2,
                                // color: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: SalesData.customerSalesType,
                                          items: _custtypelist?.map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    item['type'],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  value:
                                                      item['type'].toString(),
                                                );
                                              })?.toList() ??
                                              [],
                                          onChanged: (String newValue) {
                                            setState(() {
                                              SalesData.customerSalesType =
                                                  newValue;
                                              customerSalesTypeChanged();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      width: MediaQuery.of(context).size.width - 2,
                      height: 30,
                      color: Colors.deepOrange[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Name',
                              style: TextStyle(),
                            ),
                          ),
                          Container(
                            // width: 110,
                            child: Text(
                              SalesData.custTotalCaption,
                              style: TextStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 2,
                      height: MediaQuery.of(context).size.height / 3 - 80,
                      color: Colors.transparent,
                      child: ListView.builder(
                          padding: const EdgeInsets.only(top: 1),
                          itemCount: _custsalelist.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width:
                                        MediaQuery.of(context).size.width - 35,
                                    height: 50,
                                    color: Colors.transparent,
                                    child: Stack(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              // color: Colors.grey,
                                              // height: ,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  150,
                                              child: Text(
                                                _custsalelist[index]
                                                    ['account_name'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                // overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              formatCurrencyAmt.format(
                                                  double.parse(
                                                      _custsalelist[index]
                                                          ['total'])),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildItemCont() {
    if (viewSpinkit == true) {
      return Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: SpinKitFadingCircle(
            color: ColorsTheme.mainColor,
            size: 50,
          ),
        ),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.blue[50],
          border: Border.all(color: Colors.blue[50]),
          borderRadius: BorderRadius.circular(0)),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 2,
                      // color: Colors.grey,
                      child: Stack(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 15),
                                child: Container(
                                  child: Text(
                                    'Top Items',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 0),
                                // width: MediaQuery.of(context).size.width / 2,
                                // color: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: SalesData.itemSalesType,
                                          items: _itmtypelist?.map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    item['type'],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  value:
                                                      item['type'].toString(),
                                                );
                                              })?.toList() ??
                                              [],
                                          onChanged: (String newValue) {
                                            setState(() {
                                              SalesData.itemSalesType =
                                                  newValue;
                                              itemSalesTypeChanged();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      width: MediaQuery.of(context).size.width - 2,
                      height: 30,
                      color: Colors.blue[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Item Description',
                              style: TextStyle(),
                            ),
                          ),
                          Text(
                            SalesData.itmTotalCaption,
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 2,
                      height: MediaQuery.of(context).size.height / 2 - 80,
                      padding: EdgeInsets.only(bottom: 5),
                      // color: Colors.transparent,
                      color: Colors.blue[50],
                      child: ListView.builder(
                          padding: const EdgeInsets.only(top: 1),
                          itemCount: _itemsalelist.length,
                          itemBuilder: (context, index) {
                            if (_itemsalelist[index]['item_path'] == '') {
                              noImage = true;
                            } else {
                              noImage = false;
                            }
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width:
                                        MediaQuery.of(context).size.width - 35,
                                    height: 80,
                                    color: Colors.transparent,
                                    child: Stack(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 5,
                                              height: 80,
                                              color: ColorsTheme.mainColor,
                                            ),
                                            Container(
                                                height: 80,
                                                margin: EdgeInsets.only(
                                                    left: 3, top: 0),
                                                width: 75,
                                                color: Colors.white,
                                                child: noImage
                                                    ? Image(
                                                        image: AssetsValues
                                                            .noImageImg)
                                                    : Image.network(
                                                        UrlAddress.itemImg +
                                                            _itemsalelist[index]
                                                                ['item_path'])),
                                            Container(
                                              color: Colors.white,
                                              height: 80,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  150,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _itemsalelist[index]
                                                        ['item_desc'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    // overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              height: 80,
                                              width: 40,
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _itemsalelist[index]
                                                        ['total'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
