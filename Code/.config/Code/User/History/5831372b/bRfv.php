<?php

namespace App\Supports\OzcCalculator;

use App\Enums\PropertyType;
use App\Enums\RoofInsulationType;
use App\Enums\SubstrateType;
use App\Enums\YearOfConstruction;
use App\Enums\YearOfWindows;
use App\Services\ClimaticStationService;
use App\Services\PvGisService;
use Illuminate\Contracts\Container\BindingResolutionException;
use Illuminate\Support\Collection;

class CalculatorFactorsDto extends MathHelper
{
    //response z pvgis, TMY api.
    public Collection $pvGisTmy;

    // ------------------------------------------------------------------------------
    // Zabudowa
    // ------------------------------------------------------------------------------

    // Długość zabudowy
    public $bl;

    // Szerokość zabudowy
    public $bw;

    // Pole zabudowy
    public $ba;

    // Obwód zabudowy
    public $bp;

    // Wysokość kondygnacji w świetle
    public $fh;

    // Liczba kondygnacji ogrzewanych
    public $fhn;

    // To jest $fh + 30cm
    public $fhR;

    // Wysokość stropu piwnicy
    //    public $fhb;

    // Poziom posadowienia poniżej gruntu
    public $z;

    // Wysokość ściany kolankowej
    public $kwh;

    // ------------------------------------------------------------------------------
    // Ściany
    // ------------------------------------------------------------------------------

    // Material ściaany podstawowy
    public $ebmM;

    // Grubość Material ściaany podstawowy
    public $embD;

    // Material ściaany dodatkowy
    public $eimM;

    // Grubość Material ściaany dodatkowy
    public $eimD;

    // ------------------------------------------------------------------------------
    // Piwnica
    // ------------------------------------------------------------------------------

    // Material podstawowy stropu nad piwnicą
    public $bsbmM;

    // Grubosc materialu podstawowego stropu nad piwnicą
    public $bsbmD;

    // Material dociepleniowy stropu nad piwnicą
    public $bsimM = 0;

    // Grubosc materialu dociepleniowy stropu nad piwnicą
    public $bsimD = 0;

    // Material podstawowy dla podlogi piwnicy
    public $gsimM;

    //Grubosc  Material podstawowy dla podlogi piwnicy
    public $gsimD;

    public $lPISAEK = 2;

    // ------------------------------------------------------------------------------
    // Ściana piwnicy
    //
    // To możemy nadpisac przy uzupelnianiu dto, default mozna dac material oraz docieplenie sciany zewnetrznej
    // ------------------------------------------------------------------------------

    // Material podstawowy dla sciany zewnetrznej piwnicy
    public $ebbmM;

    //Grubosc  Material podstawowy dla sciany zewnetrznej piwnicy
    public $ebbmD;

    // Material dociepleniowy dla sciany zewnetrznej piwnicy
    public $ebimM;

    //Grubosc  Material dociepleniowy dla sciany zewnetrznej piwnicy
    public $ebimD;
    // ------------------------------------------------------------------------------

    // ------------------------------------------------------------------------------
    // Poddasze
    // ------------------------------------------------------------------------------

    public $hasAttic; // czy ma poddasze

    public $hasBasement; // czy ma poddasze

    public $isAtticHeated;

    public $isBasementHeated;

    // Material podstawowy poddasza
    public $asbmM;

    // Grubosc materialu podstawowego poddasza
    public $asbmD;

    // Material dodatkowy poddasza
    public $asimM;

    // Grubosc materialu dodatkowy poddasza
    public $asimD;

    // CZy dach ma docieplenie
    public $hasInsulation;

    // ------------------------------------------------------------------------------
    // Dach
    // ------------------------------------------------------------------------------

    // Material ocieplenia dachu
    public $rimM;

    // Grubosc Material ocieplenia dachu
    public $rimD;

    // Nie zostalo podane lub uzyte w podalszych obliczeniach
    public $uR = null;

    // Wspolczynnik przenikania okien
    public $uW;

    // Cos zwiazane ze wspolczynnikiem przenikania okien - nie podano w opisie
    public $uD;

    // Wspolczynnik korekcyjny w zaleznosci od ilosci przecinanych scian
    public $uTBEW;

    // Wspolczynnik korekcyjny w zaleznosci od podlogi
    public $uTBS;

    // Wspolczynnik korekcyjny w zaleznosci od pow. elementu
    public $uTBWD;

    // Powierzchnia okien w zaleznosci od kierunku swiata -  polnoc
    public $aWN;

    // Powierzchnia okien w zaleznosci od kierunku swiata -  wschod
    public $aWE;

    // Powierzchnia okien w zaleznosci od kierunku swiata -  poludnie
    public $aWS;

    // Powierzchnia okien w zaleznosci od kierunku swiata -  zachod
    public $aWW;

    // Powierzchnia drzwi zewnętrznych
    public $aD = 2.1 * 0.8;

    // Wspolczynnik w zaleznosci od typu dachu - 10% ( plaski ), 44% (jednopasowy), 44%, 72%, podajemy w postaci dla np. 44% = 1.44
    public $roofAreaFactor;

    // Czy wentylacja jest mechaniczna
    public $isMechanical;

    // Zyski wewnetrzne, wartosci z tabeli w zaleznosci od rodzaju budynky
    public $qINT;

    // Dane ze stacji badawczej TODO: Tymczasowo, trzeba to podmienić na dane z API ze stacji badawczej
    public $iSM;

    public $iEM;

    public $iNM;

    public $iWM;

    // Grubosc materialu izolacji pomiedzy krokwiami
    public $lMaterial;

    // Lambda materialu izolacji pomiedzy krokwiami
    public $lDrywall;

    // Grubosc krokwi
    public $wA;

    // Rozstaw krokwi
    public $wB;

    // Wysokosc krokwi
    public $hK;

    public $substrateType;

    public $esmM;

    public $esmD;

    public $assmM;

    public $assmD;

    public $gsbmM;

    public $gsbmD;

    public $eiTemp;

    public YearOfConstruction $yearOfConstruction;

    public YearOfWindows $yearOfWindows;

    public $roofInsulationType;

    public $hasAirVoid;

    public $balL;

    /**
     * @throws BindingResolutionException
     */
    public function __construct(
        array $data
    ) {

        ///step 1 - lokalizacja
        $this->pvGisTmy = collect(app()->make(PvGisService::class)->getDataByLocation($data['mapPoint'][0], $data['mapPoint'][1]));

        //ze stepu 3 - typ podloza

        //        $this->substrateType = SubstrateType::from($data['substrateType'])->value(); // wartosc typu 2, 3.5
        $this->lPISAEK = SubstrateType::from($data['substrateType'])->value(); // wartosc typu 2, 3.5

        //czy ma poddasze
        $this->hasAttic = $data['hasAttic'];

        $this->bl = $data['bl'];
        $this->bw = $data['bw'];
        $this->ba = $data['ba'];

        $this->bp = $data['bp'];
        $this->fh = $data['fh'];
        $this->fhn = $data['fhn'];
        $this->fhR = $data['fh'] + 0.3;

        //        $this->fhb = $data['fhb'];
        $this->z = $data['z'] ?? null;
        $this->kwh = $data['kwh'] ?? 0;

        $this->ebmM = $data['ebmM'];
        $this->embD = $data['embD'];
        $this->eimM = $data['eimM'];
        $this->eimD = $data['eimD'];

        $this->bsbmM = $data['bsbmM'] ?? null;
        $this->bsbmD = $data['bsbmD'] ?? null;
        $this->bsimM = $data['bsimM'] ?? null;
        $this->bsimD = $data['bsimD'] ?? null;
        $this->gsimM = $data['isBasementHeated'] ? $data['gsimM2'] : $data['gsimM'];
        $this->gsimD = $data['isBasementHeated'] ? $data['gsimD2'] : $data['gsimD'];

        $this->ebbmM = $data['ebbmM'] ?? null;
        $this->ebbmD = $data['ebbmD'] ?? null;
        $this->ebimM = $data['ebimM'] ?? null;
        $this->ebimD = $data['ebimD'] ?? null;

        $this->asbmM = $data['asbmM'] ?? null;
        $this->asbmD = $data['asbmD'] ?? null;
        $this->asimM = $data['asimM'] ?? null;
        $this->asimD = $data['asimD'] ?? null;
        $this->hasInsulation = $data['hasInsulation'] ?? false;

        $this->rimM = $data['rimM'] ?? null;
        $this->rimD = $data['rimD'] ?? null;

        $this->uW = $data['uW'];
        $this->uD = $data['uD'];
        //        $this->uTBEW = $data['uTBEW'];
        $this->uTBEW = $this->calculateUTBEW($data);
        $this->uTBS = 0.20;
        $this->uTBWD = $this->addMany(
            $data['ad'],
            $data['aWN'],
            $data['aWE'],
            $data['aWS'],
            $data['aWW'],
        );
        $this->aWN = $data['aWN'];
        $this->aWE = $data['aWE'];
        $this->aWS = $data['aWS'];
        $this->aWW = $data['aWW'];

        dd($data['isMechanical']);
        $this->isMechanical = $data['isMechanical'];

        //        $this->qINT = $data['qINT'];
        $this->qINT = PropertyType::from($data['propertyType'])->value();

        /**
         * Dane ze stacji klimatycznej
         */
        $climaticStation = app()->make(ClimaticStationService::class)->getDetailsById($data['climaticStation']);
        $monthsSum = $climaticStation['monthsSum'];

        $this->iSM = $monthsSum['I_S__90'] / 1000;
        $this->iEM = $monthsSum['I_E__90'] / 1000;
        $this->iNM = $monthsSum['I_N__90'] / 1000;
        $this->iWM = $monthsSum['I_W__90'] / 1000;

        //        $this->iSM = $data['iSM'];
        //        $this->iEM = $data['iEM'];
        //        $this->iNM = $data['iNM'];
        //        $this->iWM = $data['iWM'];

        //        $this->lMaterial = $data['lMaterial'] ?? null;
        //        $this->lDrywall = $data['lDrywall'] ?? null;

        //        $this->wA = $data['wA'] ?? null; // grubosc krokwi
        //        $this->wB = $data['wB'] ?? null; // rozstaw krokwi
        //        $this->hK = $data['hK'] ?? null; // wysokosc krokwi
        $this->wA = 0.08;
        $this->wB = 0.8;
        $this->hK = 0.16;
        $this->lMaterial = 0.16;
        $this->lDrywall = 0.25;

        $this->esmM = $data['esmM'] ?? null;
        $this->esmD = $data['esmD'] ?? null;

        //do kroku 7

        $this->assmM = $data['assmM'] ?? null;
        $this->assmD = $data['assmD'] ?? null;

        $this->aD = $data['ad'];

        $this->gsbmM = $data['isBasementHeated'] ? $data['gsbmM2'] : $data['gsbmM'];
        $this->gsbmD = $data['isBasementHeated'] ? $data['gsbmD2'] : $data['gsbmD'];

        $this->hasBasement = $data['hasBasement'];

        $this->isAtticHeated = $data['isAtticHeated'];
        $this->isBasementHeated = $data['hasBasement'] ? $data['isBasementHeated'] : false; //zeby piwnica byla ogrzewana musi wgl byc piwnica :)
        $this->roofAreaFactor = $data['roofAreaFactor'] ?? null;

        $this->eiTemp = $data['eiTemp'];

        $this->yearOfConstruction = YearOfConstruction::from($data['yearOfConstruction']);
        $this->yearOfWindows = YearOfWindows::from($data['yearOfWindows']);

        $this->hasAttic = true;

        $this->roofInsulationType = RoofInsulationType::tryFrom($data['roofInsulationType'])?->value();

        $this->hasAirVoid = $data['hasAirVoid'];

        $this->balL = $data['balL'] ?? 0;
    }

    public function calculateUTBEW($data)
    {
        return 0;
        $m3 = $data['ba'] * $data['fh'] * $data['fhn'];

        switch ($data['fh'] - 1) {
            case 0:
                return $m3 <= 100 ? 0.15 : 0.05;
            case 1:
                return $m3 <= 100 ? 0.30 : 0.20;
            default:
                return $m3 <= 100 ? 0.35 : 0.25;
        }
    }
}
