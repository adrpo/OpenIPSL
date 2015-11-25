within iPSL.Electrical.Controls.PSSE.ES.IEEET1;
model IEEET1 "IEEE Type 1 excitation system"
  import iPSL.NonElectrical.Functions.SE;

  parameter Real V_0 "Voltage magnitude at the generator terminal (pu)" annotation (Dialog(group="Power flow data"));
  parameter Real T_R = 1 "Voltage input time constant (s)";
  parameter Real K_A = 40 "AVR gain";
  parameter Real T_A = 0.04 "AVR time constant (s)";
  parameter Real V_RMAX = 7.3 "Maximum AVR output (pu)";
  parameter Real V_RMIN = -7.3 "Minimum AVR output (pu)";
  parameter Real K_E = 1 "Exciter field gain, s";
  parameter Real T_E = 0.8 "Exciter time constant (s)";
  parameter Real K_F = 0.03 "Rate feedback gain (pu)";
  parameter Real T_F = 1 "Rate feedback time constant (s)";
  parameter Real E_1 = 2.400 "Exciter saturation point 1 (pu)";
  parameter Real S_EE_1 = 0.30000E-01 "Saturation at E1";
  parameter Real E_2 = 5.0000 "Exciter saturation point 2 (pu)";
  parameter Real S_EE_2 = 0.50000 "Saturation at E2";

  Modelica.Blocks.Interfaces.RealInput VOTHSG "PSS output Upss" annotation(Placement(transformation(extent = {{-106, -14}, {-100, -8}}), iconTransformation(extent={{-146,70},
            {-126,90}})));
  Modelica.Blocks.Interfaces.RealInput VOEL "OEL output" annotation(Placement(transformation(extent = {{-106, -22}, {-100, -16}}), iconTransformation(extent={{-146,30},
            {-126,50}})));
  Modelica.Blocks.Sources.Constant Vref(k=VREF)
    annotation (Placement(transformation(extent={{-86,26},{-72,40}})));
  NonElectrical.Continuous.SimpleLag
                VR(                y_start = VR0,
    K=K_A,
    T=T_A)                                                                          annotation(Placement(transformation(extent={{-14,-8},
            {-4,2}})));
  Modelica.Blocks.Interfaces.RealOutput EFD "Output,excitation voltage" annotation(Placement(transformation(extent={{78,-28},
            {88,-16}}),                                                                                                    iconTransformation(extent={{120,-6},
            {130,6}})));
  NonElectrical.Functions.ImSE
     se1(
    SE1=S_EE_1,
    SE2=S_EE_2,
    E1=E_1,
    E2=E_2)                                      annotation(Placement(transformation(extent = {{-8, -10}, {8, 10}}, rotation = 180, origin={54,38})));
  Modelica.Blocks.Interfaces.RealInput VUEL annotation(Placement(transformation(extent = {{-106, -30}, {-100, -24}}), iconTransformation(extent={{-146,
            -10},{-126,10}})));
  Modelica.Blocks.Interfaces.RealInput EC "Input, generator terminal voltage" annotation(Placement(transformation(extent = {{-106, 0}, {-100, 6}}), iconTransformation(extent={{-146,
            -50},{-126,-30}})));
protected
  parameter Real VRMAX0(fixed = false) "Maximum AVR output (pu)";
  parameter Real VRMIN0(fixed = false) "Minimum AVR output (pu)";
  parameter Real KE0(fixed = false) "Exciter field gain, s";
  parameter Real VT0(fixed = false);
  parameter Real VREF(fixed = false) "Reference terminal voltage (pu)";
  parameter Real Efd0(fixed = false);
  parameter Real SE_Efd0(fixed = false);
  parameter Real VR0(fixed = false);

  function ini0
    input Real VRMAX;
    input Real KE;
    input Real E2;
    input Real SE2;
    input Real Efd0;
    input Real SE_Efd0;
    output Real Vrmax;
    output Real Ke;
  algorithm
    Vrmax := if VRMAX == 0 and KE > 0 then (SE2 + KE) * E2 else SE2 * E2;
    if VRMAX > 0 then
      Vrmax := VRMAX;
    end if;
    if KE == 0 then
      Ke := Vrmax / (10 * Efd0) - SE_Efd0;
    else
      Ke := KE;
    end if;
  end ini0;
public
  Modelica.Blocks.Interfaces.RealInput EFD0 "Input, generator terminal voltage"
                                                                                annotation(Placement(transformation(extent={{-108,20},
            {-102,26}}),                                                                                                    iconTransformation(extent={{-146,
            -90},{-126,-70}})));
  Modelica.Blocks.Math.Add3 sum2(k2=-1)
    annotation (Placement(transformation(extent={{-48,-2},{-38,8}})));
  Modelica.Blocks.Math.Add sum3(k2=-1)
    annotation (Placement(transformation(extent={{-32,-8},{-22,2}})));
  Modelica.Blocks.Math.Gain KE_EFD(k = KE0) annotation(Placement(transformation(extent = {{-4, -4}, {4, 4}}, rotation = 180, origin={46,16})));
  Modelica.Blocks.Math.Add sum5 annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=180,
        origin={20,18})));
  Modelica.Blocks.Math.Product VE annotation(Placement(transformation(extent = {{-4, -4}, {4, 4}}, rotation = 180, origin={36,26})));
  Modelica.Blocks.Math.Add sum4(k1=-1)
    annotation (Placement(transformation(extent={{20,-6},{30,4}})));
  NonElectrical.Continuous.SimpleLag imSimpleLag1(
    K=1,
    y_start=VT0,
    T=T_R)
    annotation (Placement(transformation(extent={{-86,-4},{-72,10}})));
public
  Modelica.Blocks.Math.Add3 sum1
    annotation (Placement(transformation(extent={{-74,-22},{-64,-12}})));
  Modelica.Blocks.Continuous.Integrator integrator(
    k=1/T_E,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=Efd0)
    annotation (Placement(transformation(extent={{42,-6},{52,4}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=V_RMAX, uMin=V_RMIN)
    annotation (Placement(transformation(extent={{2,-8},{12,2}})));
  NonElectrical.Continuous.DerivativeLag derivativeLag(
    K=K_F,
    T=T_F,
    y_start=0) annotation (Placement(transformation(extent={{12,-40},{2,-30}})));
initial equation
  VT0 = V_0;
  Efd0 = EFD0;
  SE_Efd0 = SE(EFD0, S_EE_1, S_EE_2, E_1, E_2);
  (VRMAX0, KE0) = ini0(V_RMAX, K_E, E_2, S_EE_2, Efd0, SE_Efd0);
  VRMIN0 = -VRMAX0;
  VR0 = Efd0 * (KE0 + SE_Efd0);
  VREF = VR0 / K_A + VT0 + sum1.y;
equation

  connect(VOTHSG, sum1.u1) annotation (Line(points={{-103,-11},{-75,-11},{-75,-13}},
        color={0,0,127}));
  connect(VOEL, sum1.u2) annotation (Line(points={{-103,-19},{-89.5,-19},{-89.5,
          -17},{-75,-17}}, color={0,0,127}));
  connect(VUEL, sum1.u3) annotation (Line(points={{-103,-27},{-75,-27},{-75,-21}},
        color={0,0,127}));
  connect(sum1.y, sum2.u3) annotation (Line(points={{-63.5,-17},{-58,-17},{-58,-1},
          {-49,-1}}, color={0,0,127}));
  connect(imSimpleLag1.y, sum2.u2) annotation (Line(points={{-71.3,3},{-60.65,3},
          {-60.65,3},{-49,3}}, color={0,0,127}));
  connect(EC, imSimpleLag1.u) annotation (Line(points={{-103,3},{-95.5,3},{-95.5,
          3},{-87.4,3}}, color={0,0,127}));
  connect(Vref.y, sum2.u1) annotation (Line(points={{-71.3,33},{-60,33},{-60,7},
          {-49,7}}, color={0,0,127}));
  connect(sum2.y, sum3.u1)
    annotation (Line(points={{-37.5,3},{-33,3},{-33,0}}, color={0,0,127}));
  connect(sum3.u2, derivativeLag.y) annotation (Line(points={{-33,-6},{-34,-6},{
          -34,-28},{-34,-35},{1.5,-35}}, color={0,0,127}));
  connect(sum3.y, VR.u) annotation (Line(points={{-21.5,-3},{-18.75,-3},{-18.75,
          -3},{-15,-3}}, color={0,0,127}));
  connect(VR.y, limiter.u) annotation (Line(points={{-3.5,-3},{-1.75,-3},{-1.75,
          -3},{1,-3}}, color={0,0,127}));
  connect(limiter.y, sum4.u2) annotation (Line(points={{12.5,-3},{15.25,-3},{15.25,
          -4},{19,-4}}, color={0,0,127}));
  connect(sum4.u1, sum5.y) annotation (Line(points={{19,2},{14,2},{14,18},{15.6,
          18}}, color={0,0,127}));
  connect(sum5.u2, VE.y) annotation (Line(points={{24.8,20.4},{30,20.4},{30,26},
          {31.6,26}}, color={0,0,127}));
  connect(sum5.u1, KE_EFD.y) annotation (Line(points={{24.8,15.6},{33.4,15.6},{33.4,
          16},{41.6,16}}, color={0,0,127}));
  connect(se1.VE_OUT, VE.u2) annotation (Line(points={{45.6,38.1},{44,38.1},{44,
          28.4},{40.8,28.4}}, color={0,0,127}));
  connect(sum4.y, integrator.u) annotation (Line(points={{30.5,-1},{35.25,-1},{35.25,
          -1},{41,-1}}, color={0,0,127}));
  connect(integrator.y, EFD) annotation (Line(points={{52.5,-1},{74,-1},{74,-22},
          {83,-22}}, color={0,0,127}));
  connect(derivativeLag.u, EFD) annotation (Line(points={{13,-35},{74,-35},{74,-22},
          {83,-22}}, color={0,0,127}));
  connect(se1.VE_IN, EFD) annotation (Line(points={{62.4,38.1},{74,38.1},{74,-22},
          {83,-22}}, color={0,0,127}));
  connect(VE.u1, EFD) annotation (Line(points={{40.8,23.6},{74,23.6},{74,-22},{83,
          -22}}, color={0,0,127}));
  connect(KE_EFD.u, EFD) annotation (Line(points={{50.8,16},{74,16},{74,-22},{83,
          -22}}, color={0,0,127}));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-140,
            -100},{120,100}}),                                                                           graphics={                                                                                                    Text(extent = {{10, 40}, {38, 32}}, lineColor = {0, 0, 255}, textString = "VE=SE*EFD"),                                                                                       Text(extent = {{-110, 10}, {-82, 4}}, lineColor = {0, 0, 255}, textString = "Ec"), Text(extent = {{-102, -20}, {-80, -26}}, lineColor = {0, 0, 255}, textString = "VUEL"), Text(extent = {{-102, -12}, {-80, -18}}, lineColor = {0, 0, 255}, textString = "VOEL"), Text(extent = {{-100, -2}, {-82, -12}}, lineColor = {0, 0, 255}, textString = "VOTHSG")}), Icon(coordinateSystem(preserveAspectRatio=false,   extent={{-140,
            -100},{120,100}}),                                                                                                    graphics={  Rectangle(extent={{
              -140,100},{120,-100}},                                                                                                    lineColor = {0, 0, 255}), Text(extent={{
              -126,-36},{-68,-62}},                                                                                                    lineColor=
              {0,0,255},
          textString="ECOMP
"),                                                                                        Text(extent={{
              -124,92},{-60,68}},                                                                                                    lineColor = {0, 0, 255}, textString = "VOTHSG"), Text(extent={{
              -130,8},{-80,-8}},                                                                                                    lineColor = {0, 0, 255}, textString = "VUEL"), Text(extent={{
              88,8},{118,-8}},                                                                                                    lineColor = {0, 0, 255}, textString = "EFD"), Text(extent={{
              -46,36},{54,-36}},                                                                                                    lineColor = {0, 0, 255}, textString = "IEEET1"), Text(extent={{
              -126,48},{-84,32}},                                                                                                    lineColor = {0, 0, 255}, textString = "VOEL"), Text(extent={{
              -132,-72},{-76,-88}},                                                                                                    lineColor=
              {0,0,255},
          textString="EFD0")}),
    Documentation(info="<html>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">&LT;iPSL: iTesla Power System Library&GT;</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Copyright 2015 RTE (France), AIA (Spain), KTH (Sweden) and DTU (Denmark)</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">RTE: http://www.rte-france.com/ </span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">AIA: http://www.aia.es/en/energy/</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">KTH: https://www.kth.se/en</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">DTU:http://www.dtu.dk/english</span></li>
</ul>
<p><span style=\"font-family: MS Shell Dlg 2;\">The authors can be contacted by email: info at itesla-ipsl dot org</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This package is part of the iTesla Power System Library (&QUOT;iPSL&QUOT;) .</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The iPSL is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The iPSL is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">You should have received a copy of the GNU Lesser General Public License along with the iPSL. If not, see &LT;http://www.gnu.org/licenses/&GT;.</span></p>
</html>"));
end IEEET1;
