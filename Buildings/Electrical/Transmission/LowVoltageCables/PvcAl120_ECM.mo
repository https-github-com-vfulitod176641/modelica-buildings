within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl120_ECM
  "Aluminum cable 120mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Generic(material=Types.Material.Al, M=228.1 + 273.15, RCha=0.278e-003, XCha=0.071e-003);
  annotation(Documentation(info="<html>
<p>
Aluminium cable with a cross-sectional area of 120mm^2, ECM type.
This type of cable has the following properties
</p>
<pre>
RCha = 0.278e-003 // Characteristic resistance [Ohm/m]
XCha = 0.071e-003 // Characteristic reactance [Ohm/m]
</pre>
</html>", revisions="<html>
<ul>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Revised structure of the record, now the temperature constant <code>M</code>
is directly specified in the record.
</li>
<li>
Sept 19, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end PvcAl120_ECM;
