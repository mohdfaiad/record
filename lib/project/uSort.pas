unit uSort;

interface

type
  TIntArr = array of integer;

implementation

procedure BubbleSort(var N: array of integer);
var
  I, J, IntTemp: integer;
begin
  for I := 0 to High(N) do
  begin
    for J := 0 to High(N) - 1 do
    begin
      if N[J] > N[J + 1] then
      begin
        IntTemp := N[J];
        N[J] := N[J + 1];
        N[J + 1] := IntTemp;
      end;
    end;
  end;
end;

procedure SelectSort(var N: array of integer);
var
  I, J, K, IntTemp: integer;
begin
  for I := 0 to High(N) - 1 do
  begin
    IntTemp := N[I];
    K := I;
    for J := I + 1 to High(N) do
    begin
      if IntTemp > N[J] then
      begin
        K := J;
        IntTemp := N[J];
      end;
    end;
    if K <> I then
    begin
      N[K] := N[I];
      N[I] := IntTemp;
    end;
  end;
end;

procedure InsertSort(var N: array of integer);
var
  I, J, IntTemp: integer;
begin
  for I := 1 to High(N) do
  begin
    for J := I downto 1 do
    begin
      if N[J - 1] > N[J] then
      begin
        IntTemp := N[J - 1];
        N[J - 1] := N[J];
        N[J] := IntTemp;
      end;
    end;
  end;
end;

procedure ShellSort(var N: array of integer);
var
  I, J, K, IntTemp: integer;
begin
  K := High(N) div 2;
  while K > 0 do
  begin
    for I := K to High(N) do
    begin
      J := I;
      while (J >= K) and (N[J - K] > N[J]) do
      begin
        IntTemp := N[J - K];
        N[J - K] := N[J];
        N[J] := IntTemp;
        J := J - K;
      end;
    end;
    K := K div 2;
  end;
end;

procedure QuickSort(var N: array of integer; L, R: integer);
var
  I, J, IntTemp: integer;
begin
  if L < R then
  begin
    I := L;
    J := R;
    IntTemp := N[I];
    while I < J do
    begin
      while (I < J) and (N[J] >= IntTemp) do
      begin
        J := J - 1;
      end;
      if I < J then
        N[I] := N[J];
      while (I < J) and (N[I] <= IntTemp) do
      begin
        I := I + 1;
      end;
      if I < J then
        N[J] := N[I];
    end;
    N[I] := IntTemp;
    QuickSort(N, L, I - 1);
    QuickSort(N, I + 1, R);
  end;
end;

procedure Merge(var X, Y: array of integer; L, M, R: integer);
var
  I, J: integer;
begin
  I := L;
  J := M + 1;
  while (L <= M) and (J <= R) do
  begin
    if X[L] > X[J] then
    begin
      Y[I] := X[J];
      J := J + 1;
    end
    else
    begin
      Y[I] := X[L];
      L := L + 1;
    end;
    I := I + 1;
  end;
  while L <= M do
  begin
    Y[I] := X[L];
    I := I + 1;
    L := L + 1;
  end;
  while J <= R do
  begin
    Y[I] := X[J];
    I := I + 1;
    J := J + 1;
  end;
end;

procedure MergeSort(var X, Y: TIntArr);
var
  IntLength, IntLen, IntLen_m, I: integer;
  Tmp: TIntArr;
begin
  IntLength := high(X) + 1;
  IntLen := 1;

  while IntLen < IntLength do
  begin
    IntLen_m := IntLen;
    IntLen := IntLen * 2;
    I := 0;
    while I + IntLen < IntLength do
    begin
      Merge(X, Y, I, I + IntLen_m - 1, I + IntLen - 1);
      I := I + IntLen;
    end;
    if I + IntLen_m < IntLength then
    begin
      Merge(X, Y, I, I + IntLen_m - 1, IntLength - 1);
    end;

    Tmp := X;
    X := Y;
    Y := Tmp;
  end;
end;

procedure HeapAdjust(var N: array of integer; I, IntLen: integer);
var
  IntTmp, IntChild: integer;
begin
  IntTmp := N[I];
  IntChild := 2 * I + 1;
  while IntChild < IntLen do
  begin
    if (IntChild + 1 < IntLen) and (N[IntChild] < N[IntChild + 1]) then
    begin
      IntChild := IntChild + 1;
    end;
    if N[I] < N[IntChild] then
    begin
      N[I] := N[IntChild];
      I := IntChild;
      IntChild := 2 * I + 1;
    end
    else
    begin
      break;
    end;
    N[I] := IntTmp;
  end;
end;

procedure BuildHeap(var N: array of integer);
var
  I: integer;
begin
  for I := high(N) div 2 downto 0 do
  begin
    HeapAdjust(N, I, High(N) + 1);
  end;
end;

procedure HeapSort(var X: array of integer);
var
  I, IntTmp: integer;
begin
  BuildHeap(X);
  for I := high(X) downto 0 do
  begin
    IntTmp := X[I];
    X[I] := X[0];
    X[0] := IntTmp;
    HeapAdjust(X, 0, I);
  end;
end;

end.

