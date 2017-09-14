within Buildings.Controls.OBC.ASHRAE.G36.Atomic;
block SystemRequestsReheatBox
  "Output systems requests for VAV reheat terminal unit control"

  parameter Boolean hotWatCoi=true
    "Check if there is hot water coil";
  parameter Boolean boiPla=false
    "Check if there is boiler plant";
  parameter Modelica.SIunits.Time samPer=1
    "Period of sampling cooling setpoint temperature";

  CDL.Interfaces.RealInput TRoo(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-220,150},{-180,190}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-220,420},{-180,460}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  CDL.Interfaces.RealInput uCoo(min=0, max=1, final unit="1")
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-220,70},{-180,110}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  CDL.Interfaces.RealInput VDisAir(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-220,-90},{-180,-50}}),
      iconTransformation(extent={{-10,-10},{10,10}},rotation=0, origin={-110,0})));
  CDL.Interfaces.RealInput VDisAirSet(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
      iconTransformation(extent={{-10,-10},{10,10}},rotation=0, origin={-110,20})));
  CDL.Interfaces.RealInput uDam(
    min=0, max=1, final unit="1") "Damper position"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
      iconTransformation(extent={{-10,-10},{10,10}},rotation=0, origin={-110,-20})));
  CDL.Interfaces.RealInput TDisAirSet(
    final unit="K",
    quantity="ThermodynamicTemperature") if hotWatCoi
    "Discharge airflow setpoint temperature for heating"
    annotation (Placement(transformation(extent={{-220,-230},{-180,-190}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  CDL.Interfaces.RealInput TDisAir(
    final unit="K",
    quantity="ThermodynamicTemperature") if hotWatCoi
    "Measured discharge airflow temperature"
    annotation (Placement(transformation(extent={{-220,-310},{-180,-270}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  CDL.Interfaces.RealInput uHotVal(
    min=0, max=1, final unit="1") if hotWatCoi
    "Hot water valve position"
    annotation (Placement(transformation(extent={{-220,-370},{-180,-330}}),
      iconTransformation(extent={{-10,-10},{10,10}},rotation=0, origin={-110,-90})));
  CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{180,190},{200,210}}),
      iconTransformation(extent={{100,60},{120,80}})));
  CDL.Interfaces.IntegerOutput yHotValResReq if hotWatCoi
    "Hot water reset requests"
    annotation (Placement(transformation(extent={{180,-250},{200,-230}}),
      iconTransformation(extent={{100,-60},{120,-40}})));
  CDL.Interfaces.IntegerOutput yBoiPlaReq if (hotWatCoi and boiPla)
    "Boiler plant request"
    annotation (Placement(transformation(extent={{180,-440},{200,-420}}),
      iconTransformation(extent={{100,-100},{120,-80}})));

  CDL.Discrete.Sampler samTCooSet(
    final startTime=0,
    final samplePeriod=samPer)
    "Sample current cooling setpoint"
    annotation (Placement(transformation(extent={{-140,430},{-120,450}})));
  CDL.Discrete.ZeroOrderHold zerOrdHol(
    final samplePeriod=samPer,
    final startTime=samPer/2)
    "Hold value so to record input value"
    annotation (Placement(transformation(extent={{-80,450},{-60,470}})));
  CDL.Continuous.Abs abs "Absolute change of the setpoint temperature"
    annotation (Placement(transformation(extent={{100,430},{120,450}})));
  CDL.Discrete.TriggeredSampler triSam
    "Sample the setpoint changed value when there is change"
    annotation (Placement(transformation(extent={{-120,270},{-100,290}})));
  CDL.Logical.Edge edg "Instants when input becomes true"
    annotation (Placement(transformation(extent={{-60,290},{-40,310}})));
  CDL.Logical.Latch lat "Maintains an on signal until conditions changes"
    annotation (Placement(transformation(extent={{-60,330},{-40,350}})));
  CDL.Logical.Latch lat1 "Maintains an on signal until conditions changes"
    annotation (Placement(transformation(extent={{60,260},{80,280}})));
  CDL.Logical.Timer tim
    "Calculate duration time of zone temperature exceeds setpoint by 2.8 degC"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  CDL.Logical.Timer tim1 "Calculate time"
    annotation (Placement(transformation(extent={{0,330},{20,350}})));
  CDL.Logical.Timer tim2
    "Calculate duration time of zone temperature exceeds setpoint by 1.7 degC"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  CDL.Logical.Timer tim3
    "Calculate duration time when airflow setpoint is greater than zero"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  CDL.Logical.Timer tim4 if hotWatCoi
    "Calculate duration time when discharge air temperature is less than setpoint by 17 degC"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));
  CDL.Logical.Timer tim5 if hotWatCoi
    "Calculate duration time when discharge air temperature is less than setpoint by 8.3 degC"
    annotation (Placement(transformation(extent={{0,-310},{20,-290}})));
  CDL.Continuous.Greater gre "Check if the suppression time has passed"
    annotation (Placement(transformation(extent={{60,330},{80,350}})));
  CDL.Continuous.Greater gre1
    "Check if current model time is greater than half sample period"
    annotation (Placement(transformation(extent={{-80,400},{-60,420}})));
  CDL.Continuous.Greater gre2 "Check if it is more than 2 minutes"
    annotation (Placement(transformation(extent={{-20,190},{0,210}})));
  CDL.Continuous.Greater gre3 "Check if it is more than 2 minutes"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  CDL.Continuous.Greater gre4 "Check if it is more than 1 minutes"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  CDL.Continuous.Greater gre5 if hotWatCoi
    "Check if it is more than 5 minutes"
    annotation (Placement(transformation(extent={{40,-250},{60,-230}})));
  CDL.Continuous.Greater gre6 if hotWatCoi
    "Check if it is more than 5 minutes"
    annotation (Placement(transformation(extent={{40,-310},{60,-290}})));
  CDL.Continuous.Hysteresis hys(final uLow=2.7, final uHigh=2.9)
    "Check if zone temperature is greater than cooling setpoint by 2.8 degC"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  CDL.Continuous.Hysteresis hys1(final uLow=-0.01, final uHigh=0.01)
    "Check if discharge airflow is less than 75% of setpoint"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  CDL.Continuous.Hysteresis hys2(final uLow=0.05, final uHigh=0.15)
    "Check if there is setpoint change"
    annotation (Placement(transformation(extent={{-120,330},{-100,350}})));
  CDL.Continuous.Hysteresis hys3(final uLow=1.6, final uHigh=1.8)
    "Check if zone temperature is greater than cooling setpoint by 1.7 degC"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  CDL.Continuous.Hysteresis hys4(final uLow=0.85, final uHigh=0.95)
    "Check if damper position is greater than 0.95"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
  CDL.Continuous.Hysteresis hys5(final uLow=0.85, final uHigh=0.95)
    "Check if cooling loop signal is greater than 0.95"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  CDL.Continuous.Hysteresis hys6(final uLow=-0.01, final uHigh=0.01)
    "Check if discharge airflow is less than 50% of setpoint"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  CDL.Continuous.Hysteresis hys7(final uHigh=0.01, final uLow=0.005)
    "Check if discharge airflow setpoint is greater than 0"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  CDL.Continuous.Hysteresis hys8(final uLow=-0.1, final uHigh=0.1) if hotWatCoi
    "Check if discharge air temperature is 17 degC less than setpoint"
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
  CDL.Continuous.Hysteresis hys9(final uLow=-0.1, final uHigh=0.1) if hotWatCoi
    "Check if discharge air temperature is 8.3 degC less than setpoint"
    annotation (Placement(transformation(extent={{-40,-310},{-20,-290}})));
  CDL.Continuous.Hysteresis hys10(final uLow=0.85, final uHigh=0.95)
    "Check if valve position is greater than 0.95"
    annotation (Placement(transformation(extent={{-140,-360},{-120,-340}})));
  CDL.Continuous.Hysteresis hys11(final uHigh=0.95, final uLow=0.1) if (hotWatCoi and boiPla)
    "Check if valve position is greater than 0.95"
    annotation (Placement(transformation(extent={{-140,-440},{-120,-420}})));
  CDL.Continuous.Min supTim "Suppression time"
    annotation (Placement(transformation(extent={{0,270},{20,290}})));

protected
  CDL.Continuous.Sources.ModelTime modTim "Time of the model"
    annotation (Placement(transformation(extent={{-140,400},{-120,420}})));
  CDL.Continuous.Gain gai(k=(9/5)*(5*60))
    "Convert change of degC to change of degF and find out suppression time (5 min/degF))"
    annotation (Placement(transformation(extent={{-80,270},{-60,290}})));
  CDL.Continuous.Gain gai1(final k=0.5) "50% of setpoint"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  CDL.Continuous.Gain gai2(final k=0.75) "75% of setpoint"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  CDL.Continuous.Add add1(final k1=-1)
    "Calculate difference of previous and current setpoints"
    annotation (Placement(transformation(extent={{-20,430},{0,450}})));
  CDL.Continuous.Add add2(final k1=-1)
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  CDL.Continuous.Add add3(final k1=-1)
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  CDL.Continuous.Add add4(final k2=-1)
    "Calculate difference between current discharge airflow rate and 50% of setpoint"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  CDL.Continuous.Add add5(final k1=-1)
    "Calculate difference between current discharge airflow rate and 75% of setpoint"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  CDL.Continuous.Add add6(final k2=-1) if hotWatCoi
    "Calculate difference of discharge temperature (plus 17 degC) and its setpoint"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
  CDL.Continuous.Add add7(final k2=-1) if hotWatCoi
    "Calculate difference of discharge temperature (plus 8.3 degC) and its setpoint"
    annotation (Placement(transformation(extent={{-80,-310},{-60,-290}})));
  CDL.Continuous.AddParameter addPar(final p=17, final k=1) if hotWatCoi
    "Discharge temperature plus 17 degC"
    annotation (Placement(transformation(extent={{-140,-272},{-120,-252}})));
  CDL.Continuous.AddParameter addPar1(final k=1, final p=8.3) if hotWatCoi
    "Discharge temperature plus 8.3 degC"
    annotation (Placement(transformation(extent={{-140,-330},{-120,-310}})));
  CDL.Conversions.RealToInteger reaToInt "Convert real to integer value"
    annotation (Placement(transformation(extent={{140,190},{160,210}})));
  CDL.Conversions.RealToInteger reaToInt1 "Convert real to integer value"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  CDL.Conversions.RealToInteger reaToInt2 if hotWatCoi
    "Convert real to integer value"
    annotation (Placement(transformation(extent={{140,-250},{160,-230}})));
  CDL.Conversions.RealToInteger reaToInt3 if (hotWatCoi and boiPla)
    "Convert real to integer value"
    annotation (Placement(transformation(extent={{140,-440},{160,-420}})));
  CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{40,190},{60,210}})));
  CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  CDL.Continuous.Sources.Constant con(final k=samPer/2) "Half of the sample period time"
    annotation (Placement(transformation(extent={{-140,370},{-120,390}})));
  CDL.Continuous.Sources.Constant conZer(final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-20,370},{0,390}})));
  CDL.Continuous.Sources.Constant thrCooResReq(final k=3) "Constant 3"
    annotation (Placement(transformation(extent={{40,220},{60,240}})));
  CDL.Continuous.Sources.Constant twoCooResReq(final k=2) "Constant 2"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  CDL.Continuous.Sources.Constant oneCooResReq(final k=1) "Constant 1"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  CDL.Continuous.Sources.Constant zerCooReq(final k=0) "Constant 0"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  CDL.Continuous.Sources.Constant con1(final k=120) "Two minutes"
    annotation (Placement(transformation(extent={{-60,162},{-40,182}})));
  CDL.Continuous.Sources.Constant con2(final k=120) "Two minutes"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  CDL.Continuous.Sources.Constant con3(final k=60) "One minutes"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  CDL.Continuous.Sources.Constant thrPreResReq(final k=3) "Constant 3"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  CDL.Continuous.Sources.Constant twoPreResReq(final k=2) "Constant 2"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  CDL.Continuous.Sources.Constant zerPreResReq(final k=0) "Constant 0"
    annotation (Placement(transformation(extent={{40,-180},{60,-160}})));
  CDL.Continuous.Sources.Constant onePreResReq(final k=1) "Constant 1"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  CDL.Continuous.Sources.Constant con4(final k=300) if hotWatCoi
    "Five minutes"
    annotation (Placement(transformation(extent={{0,-280},{20,-260}})));
  CDL.Continuous.Sources.Constant thrHotResReq(final k=3) if hotWatCoi
    "Constant 3"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  CDL.Continuous.Sources.Constant twoHotResReq(final k=2) if hotWatCoi
    "Constant 2"
    annotation (Placement(transformation(extent={{40,-280},{60,-260}})));
  CDL.Continuous.Sources.Constant oneHotResReq(final k=1) if hotWatCoi
    "Constant 1"
    annotation (Placement(transformation(extent={{40,-340},{60,-320}})));
  CDL.Continuous.Sources.Constant zerHotResReq(final k=0) if hotWatCoi
    "Constant 0"
    annotation (Placement(transformation(extent={{40,-380},{60,-360}})));
  CDL.Continuous.Sources.Constant zerBoiPlaReq(final k=0) if (hotWatCoi and boiPla)
    "Constant 0"
    annotation (Placement(transformation(extent={{40,-460},{60,-440}})));
  CDL.Continuous.Sources.Constant oneBoiPlaReq(final k=1) if (hotWatCoi and boiPla)
    "Constant 1"
    annotation (Placement(transformation(extent={{40,-420},{60,-400}})));
  CDL.Continuous.Sources.Constant maxSupTim(k=1800)
    "Maximum suppression time 30 minutes"
    annotation (Placement(transformation(extent={{-80,240},{-60,260}})));
  CDL.Logical.Sources.Constant con5(k=true) "Constant true"
    annotation (Placement(transformation(extent={{60,290},{80,310}})));
  CDL.Logical.Switch swi
    "Use setpoint different value when half sample period time has passed"
    annotation (Placement(transformation(extent={{40,400},{60,420}})));
  CDL.Logical.Switch swi1 "Output 3 or other request "
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  CDL.Logical.Switch swi2 "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,130},{120,150}})));
  CDL.Logical.Switch swi3 "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  CDL.Logical.Switch swi4 "Output 3 or other request "
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  CDL.Logical.Switch swi5 "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
  CDL.Logical.Switch swi6 "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));
  CDL.Logical.Switch swi7 if hotWatCoi
    "Output 3 or other request "
    annotation (Placement(transformation(extent={{100,-250},{120,-230}})));
  CDL.Logical.Switch swi8 if hotWatCoi
    "Output 2 or other request "
    annotation (Placement(transformation(extent={{100,-310},{120,-290}})));
  CDL.Logical.Switch swi9 if hotWatCoi
    "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{100,-360},{120,-340}})));
  CDL.Logical.Switch swi10 if (hotWatCoi and boiPla)
    "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{100,-440},{120,-420}})));
  CDL.Logical.TrueHoldWithReset truHol(duration=1)
    annotation (Placement(transformation(extent={{120,330},{140,350}})));
  CDL.Logical.LogicalSwitch logSwi "Logical switch"
    annotation (Placement(transformation(extent={{120,300},{140,280}})));

equation
  connect(hys.y, tim.u)
    annotation (Line(points={{-79,200},{-62,200}}, color={255,0,255}));
  connect(add2.y, hys.u)
    annotation (Line(points={{-119,200},{-102,200}}, color={0,0,127}));
  connect(TCooSet, samTCooSet.u)
    annotation (Line(points={{-200,440},{-142,440}}, color={0,0,127}));
  connect(samTCooSet.y, zerOrdHol.u)
    annotation (Line(points={{-119,440},{-100,440},{-100,460},{-82,460}},
      color={0,0,127}));
  connect(triSam.y, gai.u)
    annotation (Line(points={{-99,280},{-82,280}},color={0,0,127}));
  connect(hys2.y, lat.u)
    annotation (Line(points={{-99,340},{-61,340}}, color={255,0,255}));
  connect(lat.y, tim1.u)
    annotation (Line(points={{-39,340},{-2,340}}, color={255,0,255}));
  connect(tim1.y, gre.u1)
    annotation (Line(points={{21,340},{58,340}}, color={0,0,127}));
  connect(edg.y, triSam.trigger)
    annotation (Line(points={{-39,300},{-20,300},{-20,264},{-110,264},{-110,268.2}},
      color={255,0,255}));
  connect(lat.y, edg.u)
    annotation (Line(points={{-39,340},{-20,340},{-20,318},{-80,318},{-80,300},{-62,300}},
      color={255,0,255}));
  connect(edg.y, lat1.u0)
    annotation (Line(points={{-39,300},{-20,300},{-20,264},{59,264}},
      color={255,0,255}));
  connect(modTim.y, gre1.u1)
    annotation (Line(points={{-119,410},{-82,410}},  color={0,0,127}));
  connect(con.y, gre1.u2)
    annotation (Line(points={{-119,380},{-100,380},{-100,402},{-82,402}},
      color={0,0,127}));
  connect(zerOrdHol.y, add1.u1)
    annotation (Line(points={{-59,460},{-40,460},{-40,446},{-22,446}},
      color={0,0,127}));
  connect(samTCooSet.y, add1.u2)
    annotation (Line(points={{-119,440},{-40,440},{-40,434},{-22,434}},
      color={0,0,127}));
  connect(gre1.y, swi.u2)
    annotation (Line(points={{-59,410},{38,410}}, color={255,0,255}));
  connect(add1.y, swi.u1)
    annotation (Line(points={{1,440},{20,440},{20,418},{38,418}},
      color={0,0,127}));
  connect(conZer.y, swi.u3)
    annotation (Line(points={{1,380},{20,380},{20,402},{38,402}}, color={0,0,127}));
  connect(swi.y, abs.u)
    annotation (Line(points={{61,410},{80,410},{80,440},{98,440}},
      color={0,0,127}));
  connect(abs.y, triSam.u)
    annotation (Line(points={{121,440},{140,440},{140,360},{-140,360},{-140,280},
      {-122,280}}, color={0,0,127}));
  connect(abs.y, hys2.u)
    annotation (Line(points={{121,440},{140,440},{140,360},{-140,360},{-140,340},
      {-122,340}}, color={0,0,127}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{61,200},{98,200}}, color={255,0,255}));
  connect(thrCooResReq.y, swi1.u1)
    annotation (Line(points={{61,230},{80,230},{80,208},{98,208}}, color={0,0,127}));
  connect(add3.y, hys3.u)
    annotation (Line(points={{-119,140},{-102,140}}, color={0,0,127}));
  connect(hys3.y, tim2.u)
    annotation (Line(points={{-79,140},{-62,140}}, color={255,0,255}));
  connect(TCooSet, add2.u1)
    annotation (Line(points={{-200,440},{-160,440},{-160,206},{-142,206}},
      color={0,0,127}));
  connect(TCooSet, add3.u1)
    annotation (Line(points={{-200,440},{-160,440},{-160,146},{-142,146}},
      color={0,0,127}));
  connect(TRoo, add2.u2)
    annotation (Line(points={{-200,170},{-166,170},{-166,194},{-142,194}},
      color={0,0,127}));
  connect(TRoo, add3.u2)
    annotation (Line(points={{-200,170},{-166,170},{-166,134},{-142,134}},
      color={0,0,127}));
  connect(twoCooResReq.y, swi2.u1)
    annotation (Line(points={{61,170},{80,170},{80,148},{98,148}},
      color={0,0,127}));
  connect(swi2.y, swi1.u3)
    annotation (Line(points={{121,140},{140,140},{140,180},{80,180},{80,192},
      {98,192}}, color={0,0,127}));
  connect(and1.y, swi2.u2)
    annotation (Line(points={{61,140},{98,140}}, color={255,0,255}));
  connect(uCoo, hys5.u)
    annotation (Line(points={{-200,90},{-102,90}}, color={0,0,127}));
  connect(hys5.y, swi3.u2)
    annotation (Line(points={{-79,90},{98,90}}, color={255,0,255}));
  connect(oneCooResReq.y, swi3.u1)
    annotation (Line(points={{61,110},{80,110},{80,98},{98,98}},
      color={0,0,127}));
  connect(swi3.y, swi2.u3)
    annotation (Line(points={{121,90},{140,90},{140,120},{80,120},{80,132},
      {98,132}}, color={0,0,127}));
  connect(zerCooReq.y, swi3.u3)
    annotation (Line(points={{61,70},{80,70},{80,82},{98,82}},
      color={0,0,127}));
  connect(swi1.y, reaToInt.u)
    annotation (Line(points={{121,200},{138,200}}, color={0,0,127}));
  connect(reaToInt.y, yZonTemResReq)
    annotation (Line(points={{161,200},{190,200}}, color={255,127,0}));
  connect(gai1.y, add4.u1)
    annotation (Line(points={{-119,-40},{-100,-40},{-100,-34},{-82,-34}},
      color={0,0,127}));
  connect(VDisAir, add4.u2)
    annotation (Line(points={{-200,-70},{-100,-70},{-100,-46},{-82,-46}},
      color={0,0,127}));
  connect(VDisAirSet, gai1.u)
    annotation (Line(points={{-200,30},{-160,30},{-160,-40},{-142,-40}},
      color={0,0,127}));
  connect(add4.y, hys6.u)
    annotation (Line(points={{-59,-40},{-42,-40}}, color={0,0,127}));
  connect(hys7.y, tim3.u)
    annotation (Line(points={{-119,30},{-102,30}}, color={255,0,255}));
  connect(VDisAirSet, hys7.u)
    annotation (Line(points={{-200,30},{-142,30}}, color={0,0,127}));
  connect(tim.y, gre2.u1)
    annotation (Line(points={{-39,200},{-22,200}}, color={0,0,127}));
  connect(con1.y, gre2.u2)
    annotation (Line(points={{-39,172},{-30,172},{-30,192},{-22,192}},
      color={0,0,127}));
  connect(gre2.y, and2.u2)
    annotation (Line(points={{1,200},{14,200},{14,192},{38,192}},
      color={255,0,255}));
  connect(tim2.y, gre3.u1)
    annotation (Line(points={{-39,140},{-22,140}}, color={0,0,127}));
  connect(con2.y, gre3.u2)
    annotation (Line(points={{-39,110},{-30,110},{-30,132},{-22,132}},
      color={0,0,127}));
  connect(gre3.y, and1.u2)
    annotation (Line(points={{1,140},{14,140},{14,132},{38,132}},
      color={255,0,255}));
  connect(tim3.y, gre4.u1)
    annotation (Line(points={{-79,30},{-42,30}}, color={0,0,127}));
  connect(con3.y, gre4.u2)
    annotation (Line(points={{-79,0},{-60,0},{-60,22},{-42,22}},
      color={0,0,127}));
  connect(gre4.y, and3.u1)
    annotation (Line(points={{-19,30},{20,30},{20,-40},{38,-40}},
      color={255,0,255}));
  connect(hys6.y, and3.u2)
    annotation (Line(points={{-19,-40},{0,-40},{0,-48},{38,-48}},
      color={255,0,255}));
  connect(and3.y, swi4.u2)
    annotation (Line(points={{61,-40},{98,-40}}, color={255,0,255}));
  connect(thrPreResReq.y, swi4.u1)
    annotation (Line(points={{61,-10},{80,-10},{80,-32},{98,-32}},
      color={0,0,127}));
  connect(VDisAirSet, gai2.u)
    annotation (Line(points={{-200,30},{-160,30},{-160,-100},{-142,-100}},
      color={0,0,127}));
  connect(VDisAir, add5.u1)
    annotation (Line(points={{-200,-70},{-100,-70},{-100,-94},{-82,-94}},
      color={0,0,127}));
  connect(gai2.y, add5.u2)
    annotation (Line(points={{-119,-100},{-100,-100},{-100,-106},{-82,-106}},
      color={0,0,127}));
  connect(add5.y, hys1.u)
    annotation (Line(points={{-59,-100},{-42,-100}}, color={0,0,127}));
  connect(hys1.y, and4.u2)
    annotation (Line(points={{-19,-100},{0,-100},{0,-108},{38,-108}},
      color={255,0,255}));
  connect(gre4.y, and4.u1)
    annotation (Line(points={{-19,30},{20,30},{20,-100},{38,-100}},
      color={255,0,255}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{61,-100},{98,-100}}, color={255,0,255}));
  connect(twoPreResReq.y, swi5.u1)
    annotation (Line(points={{61,-70},{80,-70},{80,-92},{98,-92}},
      color={0,0,127}));
  connect(swi5.y, swi4.u3)
    annotation (Line(points={{121,-100},{140,-100},{140,-60},{80,-60},{80,-48},
      {98,-48}}, color={0,0,127}));
  connect(uDam, hys4.u)
    annotation (Line(points={{-200,-150},{-142,-150}}, color={0,0,127}));
  connect(hys4.y, swi6.u2)
    annotation (Line(points={{-119,-150},{98,-150}}, color={255,0,255}));
  connect(onePreResReq.y, swi6.u1)
    annotation (Line(points={{61,-130},{80,-130},{80,-142},{98,-142}},
      color={0,0,127}));
  connect(zerPreResReq.y, swi6.u3)
    annotation (Line(points={{61,-170},{80,-170},{80,-158},{98,-158}},
      color={0,0,127}));
  connect(swi6.y, swi5.u3)
    annotation (Line(points={{121,-150},{140,-150},{140,-120},{80,-120},{80,-108},
      {98,-108}}, color={0,0,127}));
  connect(swi4.y, reaToInt1.u)
    annotation (Line(points={{121,-40},{138,-40}}, color={0,0,127}));
  connect(reaToInt1.y, yZonPreResReq)
    annotation (Line(points={{161,-40},{190,-40}}, color={255,127,0}));
  connect(TDisAir, addPar.u)
    annotation (Line(points={{-200,-290},{-160,-290},{-160,-262},{-142,-262}},
      color={0,0,127}));
  connect(addPar.y, add6.u2)
    annotation (Line(points={{-119,-262},{-108,-262},{-108,-246},{-82,-246}},
      color={0,0,127}));
  connect(TDisAirSet, add6.u1)
    annotation (Line(points={{-200,-210},{-100,-210},{-100,-234},{-82,-234}},
      color={0,0,127}));
  connect(add6.y, hys8.u)
    annotation (Line(points={{-59,-240},{-42,-240}}, color={0,0,127}));
  connect(hys8.y, tim4.u)
    annotation (Line(points={{-19,-240},{-2,-240}}, color={255,0,255}));
  connect(con4.y, gre5.u2)
    annotation (Line(points={{21,-270},{30,-270},{30,-248},{38,-248}},
      color={0,0,127}));
  connect(tim4.y, gre5.u1)
    annotation (Line(points={{21,-240},{38,-240}}, color={0,0,127}));
  connect(addPar1.y, add7.u2)
    annotation (Line(points={{-119,-320},{-108,-320},{-108,-306},{-82,-306}},
      color={0,0,127}));
  connect(add7.y, hys9.u)
    annotation (Line(points={{-59,-300},{-42,-300}}, color={0,0,127}));
  connect(hys9.y, tim5.u)
    annotation (Line(points={{-19,-300},{-2,-300}}, color={255,0,255}));
  connect(con4.y, gre6.u2)
    annotation (Line(points={{21,-270},{30,-270},{30,-308},{38,-308}},
      color={0,0,127}));
  connect(tim5.y, gre6.u1)
    annotation (Line(points={{21,-300},{38,-300}}, color={0,0,127}));
  connect(gre5.y, swi7.u2)
    annotation (Line(points={{61,-240},{98,-240}}, color={255,0,255}));
  connect(thrHotResReq.y, swi7.u1)
    annotation (Line(points={{61,-210},{80,-210},{80,-232},{98,-232}},
      color={0,0,127}));
  connect(gre6.y, swi8.u2)
    annotation (Line(points={{61,-300},{98,-300}}, color={255,0,255}));
  connect(twoHotResReq.y, swi8.u1)
    annotation (Line(points={{61,-270},{80,-270},{80,-292},{98,-292}},
      color={0,0,127}));
  connect(swi8.y, swi7.u3)
    annotation (Line(points={{121,-300},{140,-300},{140,-260},{80,-260},{80,-248},
      {98,-248}}, color={0,0,127}));
  connect(TDisAir, addPar1.u)
    annotation (Line(points={{-200,-290},{-160,-290},{-160,-320},{-142,-320}},
      color={0,0,127}));
  connect(TDisAirSet, add7.u1)
    annotation (Line(points={{-200,-210},{-100,-210},{-100,-294},{-82,-294}},
      color={0,0,127}));
  connect(uHotVal, hys10.u)
    annotation (Line(points={{-200,-350},{-142,-350}}, color={0,0,127}));
  connect(hys10.y, swi9.u2)
    annotation (Line(points={{-119,-350},{98,-350}}, color={255,0,255}));
  connect(oneHotResReq.y, swi9.u1)
    annotation (Line(points={{61,-330},{80,-330},{80,-342},{98,-342}},
      color={0,0,127}));
  connect(zerHotResReq.y, swi9.u3)
    annotation (Line(points={{61,-370},{80,-370},{80,-358},{98,-358}},
      color={0,0,127}));
  connect(swi9.y, swi8.u3)
    annotation (Line(points={{121,-350},{140,-350},{140,-320},{80,-320},{80,-308},
      {98,-308}}, color={0,0,127}));
  connect(swi7.y, reaToInt2.u)
    annotation (Line(points={{121,-240},{138,-240}}, color={0,0,127}));
  connect(reaToInt2.y, yHotValResReq)
    annotation (Line(points={{161,-240},{190,-240}}, color={255,127,0}));
  connect(uHotVal, hys11.u)
    annotation (Line(points={{-200,-350},{-160,-350},{-160,-430},{-142,-430}},
      color={0,0,127}));
  connect(hys11.y, swi10.u2)
    annotation (Line(points={{-119,-430},{98,-430}}, color={255,0,255}));
  connect(oneBoiPlaReq.y, swi10.u1)
    annotation (Line(points={{61,-410},{80,-410},{80,-422},{98,-422}},
      color={0,0,127}));
  connect(zerBoiPlaReq.y, swi10.u3)
    annotation (Line(points={{61,-450},{80,-450},{80,-438},{98,-438}},
      color={0,0,127}));
  connect(swi10.y, reaToInt3.u)
    annotation (Line(points={{121,-430},{138,-430}}, color={0,0,127}));
  connect(reaToInt3.y, yBoiPlaReq)
    annotation (Line(points={{161,-430},{190,-430}}, color={255,127,0}));
  connect(gre.y, truHol.u)
    annotation (Line(points={{81,340},{119,340}}, color={255,0,255}));
  connect(truHol.y, lat.u0)
    annotation (Line(points={{141,340},{160,340},{160,320},{-80,320},{-80,334},
      {-61,334}}, color={255,0,255}));
  connect(gre.y, lat1.u)
    annotation (Line(points={{81,340},{100,340},{100,322},{44,322},{44,270},{59,270}},
      color={255,0,255}));
  connect(lat.y, logSwi.u2)
    annotation (Line(points={{-39,340},{-20,340},{-20,318},{100,318},{100,290},
      {118,290}}, color={255,0,255}));
  connect(con5.y, logSwi.u3)
    annotation (Line(points={{81,300},{104,300},{104,298},{118,298}},
      color={255,0,255}));
  connect(lat1.y, logSwi.u1)
    annotation (Line(points={{81,270},{100,270},{100,282},{118,282}},
      color={255,0,255}));
  connect(logSwi.y, and2.u1)
    annotation (Line(points={{141,290},{160,290},{160,258},{20,258},{20,200},
      {38,200}}, color={255,0,255}));
  connect(logSwi.y, and1.u1)
    annotation (Line(points={{141,290},{160,290},{160,258},{20,258},{20,140},
      {38,140}}, color={255,0,255}));
  connect(gai.y, supTim.u1)
    annotation (Line(points={{-59,280},{-40,280},{-40,286},{-2,286}},
      color={0,0,127}));
  connect(maxSupTim.y, supTim.u2)
    annotation (Line(points={{-59,250},{-40,250},{-40,274},{-2,274}},
      color={0,0,127}));
  connect(supTim.y, gre.u2)
    annotation (Line(points={{21,280},{40,280},{40,332},{58,332}}, color={0,0,127}));

annotation (
  defaultComponentName="sysReq_RehBox",
  Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-180,-460},{180,480}}), graphics={
        Rectangle(
          extent={{-158,478},{158,262}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-158,238},{158,62}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-158,38},{158,-178}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-158,-202},{158,-378}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-158,-402},{158,-458}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}), Icon(graphics={
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,96},{-62,82}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{-100,74},{-72,64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TRoo"),
        Text(
          extent={{-100,54},{-72,44}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-98,28},{-52,12}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDisAirSet"),
        Text(
          extent={{-98,4},{-64,-6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDisAir"),
        Text(
          extent={{-98,-16},{-70,-26}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-98,-42},{-52,-58}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDisAirSet"),
        Text(
          extent={{-98,-66},{-64,-76}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDisAir"),
        Text(
          extent={{-98,-86},{-64,-96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHotVal"),
        Text(
          extent={{42,82},{98,62}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yZonTemResReq"),
        Text(
          extent={{42,12},{98,-8}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yZonPreResReq"),
        Text(
          extent={{42,-38},{98,-58}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHotValResReq"),
        Text(
          extent={{58,-84},{98,-100}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yBoiPlaReq")}),
  Documentation(info="<html>
<p>
This sequence sets system reset requests, i.e. cooling supply air temperature 
reset request,   
  
  
This sequence sets the thermal zone cooling and heating setpoints. The implementation
is according to the ASHRAE Guideline 36 (G36), PART5.B.3. The calculation is done
following the steps below.
</p>
<p>a. Each zone shall have separate occupied and unoccupied heating and cooling
setpoints.</p>
<p>b. The active setpoints shall be determined by the Operation Mode of the zone
group.</p>
<ul>
<li>The setpoints shall be the occupied setpoints during Occupied, Warm up, and
Cool-down modes.</li>
<li>The setpoints shall be the unoccupied setpoints during Unoccupied, Setback,
and Setup modes.</li>
</ul>
<p>c. The software shall prevent</p>
<ul>
<li>The heating setpoint from exceeding the cooling setpoint minus 0.56 &deg;C
(1 &deg;F).</li>
<li>The unoccupied heating setpoint from exceeding the occupied heating
setpoint.</li>
<li>The unoccupied cooling setpoint from being less than occupied cooling
setpoint.</li>
</ul>
<p>d. Where the zone has a local setpoint adjustment knob/button </p>
<ul>
<li>The setpoint adjustment offsets established by the occupant shall be software
points that are persistent (e.g. not reset daily), but the actual offset used
in control logic shall be adjusted based on limits and modes as described below.</li>
<li>The adjustment shall be capable of being limited in softare. (a. As a default,
the active occupied cooling setpoint shall be limited between 22 &deg;C
(72 &deg;F) and 27 &deg;C (80 &deg;F); b. As a default, the active occupied
heating setpoint shall be limited between 18 &deg;C (65 &deg;F) and 22 &deg;C
(72 &deg;F);)</li>
<li>The active heating and cooling setpoint shall be independently adjustable,
respecting the limits and anti-overlap logic described above. If zone thermostat
provides only a single setpoint adjustment, then the adjustment shall move both
the same amount, within the limits described above.</li>
<li>The adjustment shall only affect occupied setpoints in Occupied mode, and
shall have no impact on setpoints in all other modes.</li>
<li>At the onset of demand limiting, the local setpoint adjustment value shall
be frozen. Further adjustment of the setpoint by local controls shall be suspended
for the duration of the demand limit event.</li>
</ul>
<p>e. Cooling demand limit setpoint adjustment</p>
The active cooling setpoints for all zones shall be increased when a demand limit
is imposed on the associated zone group. The operator shall have the ability
to exempt individual zones from this adjustment through the normal
Building Automation System (BAS) user
interface. Changes due to demand limits are not cumulative.
<ul>
<li>At Demand Limit Level 1, increase setpoint by 0.56 &deg;C (1 &deg;F).</li>
<li>At Demand Limit Level 2, increase setpoint by 1.1 &deg;C (2 &deg;F).</li>
<li>At Demand Limit Level 1, increase setpoint by 2.2 &deg;C (4 &deg;F).</li>
</ul>
<p>f. Heating demand limit setpoint adjustment</p>
The active heating setpoints for all zones shall be decreased when a demand limit
is imposed on the associated zone group. The operator shall have the ability
to exempt individual zones from this adjustment through the normal BAS user
interface. Changes due to demand limits are not cumulative.
<ul>
<li>At Demand Limit Level 1, decrease setpoint by 0.56 &deg;C (1 &deg;F).</li>
<li>At Demand Limit Level 2, decrease setpoint by 1.1 &deg;C (2 &deg;F).</li>
<li>At Demand Limit Level 1, decrease setpoint by 2.2 &deg;C (4 &deg;F).</li>
</ul>
<p>g. Window switches</p>
For zones that have operable windows with indicator switches, when the window
switch indicates the window is open, the heating setpoint shall be temporarily
set to 4.4 &deg;C (40 &deg;F) and the cooling setpoint shall be temporarily
set to 49 &deg;C (120 &deg;F). When the window switch indicates the window is
open during other than Occupied Mode, a Level 4 alarm shall be generated.
<p>h. Occupancy sensor</p>
<ul>
<li>When the switch indicates the space has been unpopulated for 5 minutes
continuously during the Occupied Mode, the active heating setpoint shall be
decreased by 1.1 &deg;C (2 &deg;F) and the cooling setpoint shall be increased
by 1.1 &deg;C (2 &deg;F).</li>
<li>When the switch indicated that the space has been populated for 1 minute
continuously, the active heating and cooling setpoints shall be restored to
their previously values.</li>
</ul>
<p>Hierarchy of setpoint adjustments: the following adjustment restrictions
shall prevail in order from highest to lowest priority.</p>
<ul>
<li>Setpoint overlap restriction (Part c)</li>
<li>Absolute limits on local setpoint adjustment (Part d)</li>
<li>Window swtiches (Part g)</li>
<li>Demand limit (a. Occupancy sensors; b. Local setpoint adjustment)</li>
<li>Scheduled setpoints based on zone group mode</li>
</ul>

<h4>References</h4>
<p>
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR (ANSI Board of
Standards Review)/ASHRAE Guideline 36P,
<i>High Performance Sequences of Operation for HVAC systems</i>.
First Public Review Draft (June 2016)</a>
</p>

</html>", revisions="<html>
<ul>
<li>
August 17, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SystemRequestsReheatBox;
