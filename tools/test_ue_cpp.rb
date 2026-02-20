require 'rouge'
require './_plugins/rouge_ue_cpp'

code = <<~CPP
  // UE primitive types
  int32 Count = 0;
  uint8 Flags = 0;
  uint32 Hash = 0;
  int64 BigNum = 0;
  TCHAR Ch = TEXT('A');
  ANSICHAR AnsiBuf[256];
  float32 Val;

  // UE casting
  AActor* Actor = Cast<AActor>(Object);
  ACharacter* Char = CastChecked<ACharacter>(Pawn);

  // Lambda
  TArray<int32> Arr;
  Arr.Sort([](const int32 A, const int32 B) { return A < B; });

  // Initializer list
  FVector Vec = { 1.0f, 2.0f, 3.0f };

  // auto
  auto MyActor = GetWorld()->SpawnActor<AActor>();
CPP

formatter = Rouge::Formatters::HTML.new
lexer = Rouge::Lexers::UECpp.new
puts formatter.format(lexer.lex(code))
