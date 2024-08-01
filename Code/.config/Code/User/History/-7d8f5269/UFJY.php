<?php

namespace App\Http\Requests;

use App\Enums\PropertyType;
use App\Enums\RoofInsulationType;
use App\Enums\SubstrateType;
use App\Enums\TypesOfVentilation;
use App\Enums\YearOfConstruction;
use App\Enums\YearOfWindows;
use App\Http\Requests\StepByStepForm\StepByStepRequest;
use App\Services\ClimaticStationService;
use Illuminate\Validation\Rules\Enum;

class CalculatorFactorsRequest extends StepByStepRequest
{
    public static function getFormName(): string
    {
        return 'calculation-form';
    }

    public static int $stepsCount = 8;

    public function validateStepByStep(): void
    {
        /**
         * Step 1
         */
        $this->validateStep([
            'propertyType' => [
                'required',
                new Enum(PropertyType::class),
            ],
        ]);

        /**
         * Step 2
         */
        $this->validateStep([
            'mapPoint' => [
                'required',
                'array',
                function ($attribute, $value, $fail) {
                    if (count($value) !== 2 || ! is_numeric($value[0]) || ! is_numeric($value[1])) {
                        $fail('Pole mapPoint musi być listą zawierającą dwie wartości numeryczne: [latitude, longitude].');
                    }
                },
            ],

            'climaticStation' => [
                'required',
                'integer',
                function ($attribute, $value, $fail) {
                    $exists = app()->make(ClimaticStationService::class)->hasStationDetailsInStorage($value);
                    if (! $exists) {
                        $fail('Potrzebujemy informacji o stacji pogodowej.');
                    }
                },
            ],
        ]);

        /**
         * Step 3
         * Legacy: fhW, isMechanical, isAtticHeated, isBasementHeated
         */
        $this->validateStep([
            /* Zabudowa */
            'yearOfConstruction' => [                   // Rok zabudowy
                'required',
                new Enum(YearOfConstruction::class),
            ],
            'typeOfVentilation' => [                    // Rodzaj wentylacji, zastępuje pole isMechanical
                'required',
                new Enum(TypesOfVentilation::class),
            ],
            'totalInhabitants' => 'required|integer',   // Liczba osób mieszkających

            /* Wymiary */
            'bl' => 'required|numeric',                 // Długość zabudowy [m]
            'bw' => 'required|numeric',                 // Szerokość zabudowy [m]
            'bp' => 'required|numeric',                 // Obwód zabudowy [m]
            'ba' => 'required|numeric',                 // Powierzchnia zabudowy [m²]

            /* Kondygnacje */
            'fhn' => 'required|numeric',                // Liczba kondygnacji ogrzewanych
            'fh' => 'required|numeric',                 // Wysokość kondygnacji [m] (+30cm) zmiana z cm -> m jest na froncie
            'eiTemp' => 'required|numeric',             // Oczekiwana temperatura wewnetrzna
            'substrateType' => [                        // Typ podłoża
                'required',
                new Enum(SubstrateType::class),
            ],
            'hasBasement' => 'required|boolean',        // Czy dom ma piwnicę?
            'hasAttic' => 'required|boolean',           // Czy dom ma poddasze?

            /* Materiał podstawowy */
            // Jeśli nie ma piwnicy, to te pola są do wypełnienia
            // vvv - w przypadku gdy nie wybierzemy piwnice, to pola pod powierzchni podlogi bierzemy tutaj
            'gsimM' => 'required_if:hasBasement,false|nullable|numeric', // Materiał podłogi
            'gsimD' => 'required_if:hasBasement,false|nullable|numeric', // Grubość podłogi [m]

            /* Materiał izolacyjny */
            'gsbmM' => 'required_if:hasBasement,false|nullable|numeric', // Materiał izolacyjny podłogi
            'gsbmD' => 'required_if:hasBasement,false|nullable|numeric', // Grubość izolacyjny podłogi [m]
        ]);

        /**
         * Step 4
         */
        $this->validateStep([
            //material podstawowy scian zewnetrznych
            'ebmM' => 'required|numeric',
            'embD' => 'required|numeric',

            //material dodatkowy scian zewnetrznych
            'esmM' => 'nullable|numeric',
            'esmD' => 'required_with:esmM|nullable|numeric',

            //izolacje scian zewnetrznych
            'eimM' => 'nullable|numeric',
            'eimD' => 'required_with:eimM|nullable|numeric',

            'hasAirVoid' => 'required|boolean',

            'balL' => 'required|numeric',
        ]);

        /**
         * Step 5
         */
        $this->validateStep([
            'uW' => 'required|numeric',
            'uD' => 'required|numeric',

            'aWN' => 'required|numeric',
            'aWE' => 'required|numeric',
            'aWS' => 'required|numeric',
            'aWW' => 'required|numeric',

            'ad' => 'required|numeric',

            'yearOfWindows' => [
                'required',
                new Enum(YearOfWindows::class),
                function ($attribute, $value, $fail) {
                    $yearOfConstruction = YearOfConstruction::tryFrom($this->input('yearOfConstruction'));
                    if (! $yearOfConstruction->value) {
                        $fail('Wróć do poprzednich kroków i wybierz odpowiedni rok zabudowy');

                        return;
                    }
                    if ($value < $yearOfConstruction->value) {
                        $fail('Rok okien nie może być starszy niż rok zabudowy '.$yearOfConstruction->description());
                    }
                },
            ],
        ]);

        /**
         * Step 6 - Dach
         */
        $this->validateStep([
            //            'lDrywall' => 'nullable|numeric',
            //            'lMaterial' => 'required_with:lDrywall|nullable|numeric',
            'roofAreaFactor' => 'required|numeric',

            //            'wA' => 'required|numeric', - grubosc krokwi
            //            'wB' => 'required|numeric', - rozstaw krokwi
            //            'hK' => 'required|numeric', - wysokosc krokwi

            'rimM' => 'required|numeric',
            'rimD' => 'required|numeric',
            'kwh' => 'required|numeric',

            //            'hasInsulation' => 'required|boolean', // i tak jest na sztywno we wzorze true
        ]);

        /**
         * Step 7
         */
        $this->validateStep([
            'asbmM' => 'required|numeric|min:0.01',
            'asbmD' => 'required|numeric',

            'asimM' => 'nullable|numeric',
            'asimD' => 'required_with:asimM|nullable|numeric',

            'assmM' => 'nullable|numeric',
            'assmD' => 'required_with:assmM|nullable|numeric',

            'roofInsulationType' => [
                'required',
                new Enum(RoofInsulationType::class),
            ],
        ]);

        /**
         * Step 8
         */
        $this->validateStep([
            'bsbmM' => 'required|numeric',
            'bsbmD' => 'required|numeric',
            'bsimM' => 'nullable|numeric',
            'bsimD' => 'required_with:bsimM|nullable|numeric',

            'gsimM2' => 'required|numeric',
            'gsimD2' => 'required|numeric',

            'ebbmM' => 'required|numeric',
            'ebbmD' => 'required|numeric',

            'ebimM' => 'nullable|numeric',
            'ebimD' => 'required_with:ebimM|nullable|numeric',
            'fhb' => 'required|numeric',
            'z' => 'required|numeric',

            'gsbmM2' => 'required|numeric',
            'gsbmD2' => 'required|numeric',
        ]);

        /**
         * Step 9
         */
        $this->validateStep([
            'name' => 'required|string',

            // Ściana piwnicy
            // 'lPISAEK' => 'nullable|numeric',

            'uTBEW' => 'required|numeric',
            'uTBS' => 'required|numeric',
            'uTBWD' => 'required|numeric',

            // Wentylacja

            'qINT' => 'required|numeric',
        ]);
    }

    public static function skipSteps(bool $dataFromSession = false): array
    {
        $data = ! $dataFromSession ? request()->all() : self::getStepsDataFromSession();

        $skipSteps = [];

        if (
            //            ($data['hasBasement'] ?? null) &&
            ! ($data['isBasementHeated'] ?? null)
        ) { // piwnica
            $skipSteps[] = 8;
        }

        if (! self::hasBasement($data)) { //poddasze
            $skipSteps[] = 8;
        }

        if (
            ($data['isAtticHeated'] ?? null) //jest ogrzewane
        ) { //poddasze
            $skipSteps[] = 7; //ukrywamy poddasze
        } else {
            $skipSteps[] = 6; // dach
        }

        return $skipSteps;
    }

    private static function hasBasement(array $data): bool
    {
        return $data['hasBasement'] === 'true';
    }

    private static function hasAttic(array $data): bool
    {
        return $data['hasAttic'] === 'true';
    }

    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }
}
