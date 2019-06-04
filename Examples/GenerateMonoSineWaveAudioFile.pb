
EnableExplicit


; Importing the include
XIncludeFile "../BasicWaveHeader.pbi"


;- Declaring Wave structure

; Uncompressed, Mono, 384000bps ???, 8bit-depth, 3sec worth of samples
Define *Wav.WAVFormat = CreateStaticWaveStructure(1, 1, 48000, 8, 48000 * 3)

If Not *Wav
	Debug "Wave Structure creation failure !"
	End 1
EndIf


;- Creating sine wave samples
; Note: Make sure you are using doubles or floats to avoid type casting errors !

Define Frequency.d = 400 ; in Hz

; Temporary variables
; Note: Don't forget to change the type of "value" if the bit-depth is not 8.
Define Amplitude.d
Define Value.b

Define i.q

For i=0 To MemorySize(*Wav\dat\Data)
	; A(t) = (2 * pi * Frequency / StepsPerSecond * CurrentStep)
	; I don't know why the hell you need to multiply pi by 2, but if you don't, you get a sine wave at half the frequency...
	Amplitude = Sin(((2 * #PI * Frequency) / *Wav\fmt\SampleRate) * i)
	
	; This make the amplitude range from ]-128;127].
	; Multiplying by 128 could have cause some overflow if Amplitude was equal to 1.0.
	Value = 127 + (Amplitude * 127)
	
	; Writing the calculated sample in the Wave's sample buffer.
	PokeA(*Wav\dat\Data + i, Value)
Next


;- Exporting to .wav file

If CreateFile(0, "./out-"+Str(Date())+"-"+Str(Frequency)+"Hz.wav")
	; Writing the first 2 chunks of the Wave file and the 2 first fields of the data subchunk.
	WriteData(0, *Wav, SizeOf(RIFFChunk) + SizeOf(fmtChunk) + 2*4)
	
	; Writing the samples buffer.
	WriteData(0, *Wav\dat\Data, MemorySize(*Wav\dat\Data))
	
	CloseFile(0)
Else
	Debug "File creation failure !"
EndIf

FreeWaveStructure(*Wav)

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 16
; EnableXP