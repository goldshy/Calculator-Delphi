program Kalkulacka2_P;

uses
  Vcl.Forms,
  kalkulacka2_U in 'kalkulacka2_U.pas' {form_Kalkulacka};


{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tform_Kalkulacka, form_Kalkulacka);
  Application.Run;
end.
