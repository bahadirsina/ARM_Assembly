		AREA ORNEK,CODE,READONLY
		ENTRY
		EXPORT main
			
main	PROC
		LDR R1, =arrayA		; R1'de A dizisinin ilk elemaninin adresi tutulur
		MOV R6, #4		; R6'da 4 bit integer degeri tutulur
		LDR R5, [R1]	; A dizisinin boyutu R5'de tutulur
		MOV	R2, #2		; #1 olursa find, #2 olursa sort islemi
		MOV R3, #0		; offset
				
		CMP R2, #1		; R2 1 ile karsilastir 		
		BEQ find		; esit ise find islemi
		
		CMP R2, #2		; R2 2 ile karsilastir		
		BEQ sort		; esit ise sort islemi
		 
find
		MOV R0, #4		; Aranacak olan sayiyi belirtir
		MUL R4, R5, R6 	; Dizinin donecegi miktar
		MOV R8, R0		; Temp olarak R0 degeri R8'de tutulur
		
forLoop_find
		ADD R3, R3, #4	; offset degeri 4 bit olarak arttirilir
		CMP R3, R4		; dizinin boyutuna ulastigi kontrol edilir
		BLE islem_forLoop_find	; dizinin boyutundan az veya esit ise islem kismina gecilir
		B notFindNumber
		
islem_forLoop_find
		LDR R7, [R3,R1]	; R7'de dizinin adresine offset degeri kadar eklenerek o adresteki sayi tutulur
		CMP R7, R8		; Bu sayi eger bizim temp olarak tuttugumuz aradigimiz deger ise
		BEQ	findNumber	; findNumber'a branch edilir
		MOV R0,#0		; eger sayi esit degilse R0'in degeri 0 olur
		B forLoop_find	; Dongu devam eder
		
findNumber
		MOV R0,#1		; eger sayi bulunursa R0'in degeri 1 olur
		ADD R1,R3,R1	; ayni zamanda R1 degeri artik bulunan sayinin adresini tutar
		B son			; aranan deger bulundugu icin islem bitirilir

notFindNumber
		B son
sort 
		LDR R0, [R1]	; A dizisinin boyutu R0'da tutulur		
		MOV R4, #4		; Offset degeri
		MUL R9, R0, R4 	; Dizinin donecegi miktar
		LDR R7, [R1,R4]	; R7'de dizinin ikinci elemani max sayi olarak tutulur. Cunku ilk eleman size'i verir
		;ADD R4, R4, #4	; Dizinin max elemani icin 2. elemandan baslanir
		B maxSayi	; Max sayiyi bulan dongu baslar
		
maxSayi	
		ADD R4, R4, #4	; Dizinin diger elemanlarina erismek icin offset degeri arttirilir.
		CMP R4, R9 		; Offset degeri ile dongunun donecegi miktar karsilastirilir
		BLE maxSayiLoop	; Offset degeri kucuk esit ise dongu devam eder
		B maxEND		; Eger kucukse dongu sonlanir
		
maxSayiLoop		
		LDR R8, [R1,R4]	; Yeni sayi R8'de tutulur.
		CMP R8, R7		; R8 de tutulan sayi ile daha onceki max sayi karsilastirilir
		BGT islem_maxSayiLoop	; Eger yeni sayi max sayidan buyukse islem_maxSayiLoop'a gecilir
		B maxSayi	
		
islem_maxSayiLoop	
		MOV R7, R8 	; Max sayi artik yeni sayi olur
		B maxSayi	; Dongu devam eder
		
maxEND			

maxSizeArray
		LDR R9, =arrayTemp   ; Dizinin adresini R9'a yukle
		MOV R10, #0       ; Sifir degeri icin gecici bir kaydedici (register)
		MOV R11, #0       ; Sayac
		ADD R7, R7, #1	  ; +1 ekledik
		
fill_maxSizeArray
		STR R10, [R9, R11]   ; Diziye sifir degerini atama
		ADD R11, R11, #4     ; Bir sonraki indise gec
		CMP R11, R7         ; Sayac, dizi boyutuna ulasti mi?
		BLT fill_maxSizeArray  

arrayElements
		MOV R8, #1	; A arrayinin 2. elemanindan baslamak icin tutulan offset degeri
		B arrayElementsLoop

arrayElementsLoop
		CMP R8, R5	; Offset degeri ile dongunun donecegi miktar karsilastirilir
		BLE arrayElementsLoopIslem	; Offset degeri kucuk esit ise dongu devam eder
		B arrayElementsEND
		
arrayElementsLoopIslem
		LDR R10, [R1, R8, LSL#2] ; 4 * arrayA[i] kadar ilerlenir 
		LDR R11, [R9, R10, LSL#2]; 4 * arrayTemp[arrayA[i]] kadar ilerlenir
		ADD R11, #1	; arrayTemp[arrayA[i]]'e karsilik gelen sayi 1 arttirildi 
		STR R11, [R9, R10, LSL#2]; +1 eklenen sayi tekrardan arrayTemp[arrayA[i]]'e yazildi
		ADD R8, R8,#1	; A arrayinin offset degeri arttirildi
		B arrayElementsLoop

arrayElementsEND

sumArrayElements
		MOV R8, #1	; Temp arrayi icin offset degeri
		SUB R7, R7, #1	; max degeri dogru kullanmak icin 1 azaltildi
		B sumArrayElementsLoop

sumArrayElementsLoop
		CMP R8, R7	; Offset degeri ile dongunun donecegi miktar karsilastirilir
		BLE sumArrayElementsLoopIslem	; Offset degeri kucuk esit ise dongu devam eder
		B sumArrayElementsEND
		
sumArrayElementsLoopIslem
		LDR R10, [R9, R8, LSL#2]	; 4 * arrayTemp[i] kadar ilerlenir, R10'a deger kaydedilir
		SUB R8, R8, #1	; arrayTemp[i-1] olacagindan offset degerindan 1 cikarilir
		LDR R11, [R9, R8, LSL#2]	; 4 * arrayTemp[i-1] kadar ilerlenir, R11'e deger kaydedilir
		ADD R8, R8, #1	; offset degeri 1 arttirilarak normal degerine dondurulur
		ADD R10, R10, R11	; arrayTemp[i] += arrayTemp[i-1];
		STR R10, [R9, R8, LSL#2]
		ADD R8, R8, #1	; offset degeri 1 arttirilarak dongu saglanir
		B sumArrayElementsLoop

sumArrayElementsEND

writeSortElements
		LDR R12, =arrayTemp2 				
		MOV R8, #1	; A arrayinin 2. elemanindan baslamak icin tutulan offset degeri
		B writeSortElementsLoop		
				
writeSortElementsLoop	
		CMP R8, R5	; Offset degeri ile dongunun donecegi miktar karsilastirilir
		BLE writeSortElementsLoopIslem	; Offset degeri kucuk esit ise dongu devam eder
		B writeSortElementsEND

writeSortElementsLoopIslem
		LDR R10, [R1, R8, LSL#2] ; 4 * arrayA[i] kadar ilerlenir 
		LDR R11, [R9, R10, LSL#2]; 4 * arrayTemp[arrayA[i]] kadar ilerlenir
		SUB R11,R11, #1
		LDR R2, [R12, R11, LSL#2]; 4 * arrayTemp2[arrayTemp[arrayA[i]]] kadar ilerlenir
		MOV R2, R10	; 4 * arrayTemp2[arrayTemp[arrayA[i]]] = 4 * arrayA[i]
		STR R2, [R12, R11, LSL#2]; Sayi arrayTemp2[arrayTemp[arrayA[i]]] icine tekrardan yazilir
		ADD R11,R11, #1
		SUB R11, #1	; arrayTemp[arrayA[i]]'e karsilik gelen sayi 1 azaltildi
		STR R11, [R9, R10, LSL#2]; 1 cikarilan sayi tekrardan arrayTemp[arrayA[i]]'e yazildi 
		ADD R8, R8,#1	; A arrayinin offset degeri arttirildi
		B writeSortElementsLoop
		
writeSortElementsEND

		LDR R0, =arrayTemp2 ; Siralanmis dizinin ilk adresi alindi. Adrese 4 eklenmesenin sebebi adresi +4 ekleyerek basladigi icin
		ADD R0, R0, #4	;Islem sonunda, siralanmis listenin ilk elemaninin adresi R0 kaydinda tutuldu

son		b son	
		ENDP
			
			
arrayA	DCD	12, 2, 0, 2, 3, 3, 0, 1, 0, 0, 4, 2, 5

	
		AREA    MyData,DATA,READWRITE
   
arrayTemp  SPACE 100    ; 100 boyutlu dizi
arrayTemp2  SPACE 100    ; 100 boyutlu dizi
		END