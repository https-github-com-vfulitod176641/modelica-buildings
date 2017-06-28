within Buildings.Experimental.OpenBuildingControl.CDL.Psychrometrics.Validation;
model h_TDryBulPhi "Model to test the specific enthalpy computation"
  extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Psychrometrics.h_TDryBulPhi   hBulPhi
   "Model for specific enthalpy computation"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant p(k=101325) "Pressure"
                                    annotation (Placement(transformation(extent={{-64,-42},
            {-44,-22}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp phi(
    duration=1,
    height=1,
    offset=0.001) "Relative humidity"   annotation (Placement(transformation(extent={{-64,-10},
            {-44,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant TDryBul(k=273.15 + 29.4)
    "Dry bulb temperature"          annotation (Placement(transformation(extent={{-64,24},
            {-44,44}})));

 // ============ Below blocks are from Buildings Library ============
  // ===================================================================

equation
  connect(TDryBul.y, hBulPhi.TDryBul)   annotation (Line(points={{-43,34},{0,34},{0,8},{45,8}}, color={0,0,127}));
  connect(phi.y, hBulPhi.phi)   annotation (Line(points={{-43,0},{0,0},{45,0}}, color={0,0,127}));
  connect(p.y, hBulPhi.p) annotation (Line(points={{-43,-32},{0,-32},{0,-8},{45,
          -8}}, color={0,0,127}));
    annotation (experiment(StopTime=1.0, Tolerance = 1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Psychrometrics/Validation/h_TDryBulPhi.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This examples is a unit test for the specific enthalpy computation <a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Psychrometrics.h_TDryBulPhi\">
Buildings.Experimental.OpenBuildingControl.CDL.Psychrometrics.h_TDryBulPhi</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 7, 2017 by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end h_TDryBulPhi;
