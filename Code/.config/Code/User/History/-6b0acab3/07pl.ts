import { Nullable } from 'primevue/ts-helpers';
import { MaterialResource } from '@/Resources/Material.resource';
import { IsolatorResource } from '@/Resources/Isolator.resource';
import { WindowResource } from '@/Resources/Window.resource';
import { DoorResource } from '@/Resources/Door.resource';
import { ClimaticStationResource } from '@/Resources/ClimaticStation.resource';
import type L from 'leaflet';
import { SeeklyAddressResource } from '@/Resources/SeeklyAddress.resource';
import { RoofTypeResource } from '@/Resources/RoofType.resource';
import { StepByStepService } from '@/Services/StepByStepService';
import { EnumOptionsResource } from '@/Resources/EnumOptions.resource';
import { ref } from 'vue';

export type CalculationForm = {
    /**
     * Step 1
     */

    propertyType: EnumOptionsResource | string | null;

    /**
     * Step 2
     */

    climaticStation: Nullable<ClimaticStationResource>;
    selectedLocation: SeeklyAddressResource | null;
    mapPoint: L.PointExpression;

    /**
     * Step 3 - Ogólne
     */

    yearOfConstruction: Nullable<EnumOptionsResource>;
    typeOfVentilation: Nullable<EnumOptionsResource>;
    totalInhabitants: Nullable<number>;

    bl: Nullable<number>;
    bw: Nullable<number>;
    bp: Nullable<number>;
    ba: Nullable<number>;

    fhn: Nullable<number>;
    fh: Nullable<number>;
    eiTemp: Nullable<number>;
    substrateType: Nullable<EnumOptionsResource>;
    hasBasement: boolean;
    hasAttic: boolean;

    // TODO:
    // isBasementHeated: boolean;

    gsimM: string | MaterialResource;
    gsimD: Nullable<number>;

    gsbmM: Nullable<number>;
    gsbmD: Nullable<number>;

    /**
     * Step 4
     */

    ebmM: string | MaterialResource;
    embD: Nullable<number>;
    eimM: string | MaterialResource;
    eimD: Nullable<number>;

    esmM: Nullable<number>;
    esmD: Nullable<number>;

    hasAirVoid: boolean;

    balL: number;
    /**
     * Step 5
     */

    uW: string | WindowResource;
    uD: string | DoorResource;

    aWN: Nullable<number>;
    aWE: Nullable<number>;
    aWS: Nullable<number>;
    aWW: Nullable<number>;

    ad: Nullable<number>;

    yearOfWindows: Nullable<EnumOptionsResource>;

    /**
     * Step 6 - Dach
     */

    // lDrywall: string | IsolatorResource;
    // lMaterial: Nullable<number>;
    roofAreaFactor: string | RoofTypeResource;

    wA: Nullable<number>;
    wB: Nullable<number>;
    hK: Nullable<number>;

    rimM: Nullable<number>;
    rimD: Nullable<number>;

    hasInsulation: boolean;

    /**
     * Step 7 - Poddasze
     */

    isAtticHeated: boolean;
    kwh: Nullable<number>;

    asbmM: string | MaterialResource;
    asbmD: Nullable<number>;
    assmM: Nullable<number>;
    assmD: Nullable<number>;
    asimM: string | MaterialResource;
    asimD: Nullable<number>;

    roofInsulationType: Nullable<EnumOptionsResource>;

    /**
     * Step 8 - Piwnica
     */

    bsbmM: string | MaterialResource;
    bsbmD: Nullable<number>;
    bsimM: string | IsolatorResource;
    bsimD: Nullable<number>;

    gsimM2: string | MaterialResource;
    gsimD2: Nullable<number>;

    ebbmM: string | MaterialResource;
    ebbmD: Nullable<number>;

    ebimM: string | IsolatorResource;
    ebimD: Nullable<number>;
    fhb: Nullable<number>;
    z: Nullable<number>;

    gsbmM2: Nullable<number>;
    gsbmD2: Nullable<number>;

    /**
     * Pozostałe
     */

    name: string;

    uTBEW: Nullable<number>;
    uTBS: Nullable<number>;
    uTBWD: Nullable<number>;

    qINT: Nullable<number>;

    test: Nullable<number>; // TODO: tymczasowo
};
export const calculationForm: CalculationForm = {
    /**
     * Step 1 - Typ Zabudowy
     */

    propertyType: null,

    /**
     * Step 2 - Lokalizacja
     */

    climaticStation: null,
    mapPoint: [52.2330335, 20.8963918],
    selectedLocation: null,

    /**
     * Step 3 - Ogólne
     */

    yearOfConstruction: null,
    typeOfVentilation: null,
    totalInhabitants: null, // Liczba osób mieszkających

    bl: null,
    bw: null,
    ba: null,

    bp: null,
    fh: null,
    fhn: null,

    isMechanical: false, // Wentylacja mechaniczna
    hasBasement: true, // Piwnica, jest na true, żeby sekcja wysunęła się, gdy użytkownik to odznaczy
    hasAttic: false, // Poddasze

    isBasementHeated: false,

    substrateType: null,

    eiTemp: null,

    gsimM: '',
    gsimD: null,

    gsbmM: null,
    gsbmD: null,

    /**
     * Step 4 - Ściana zewnetrzna
     */

    ebmM: '',
    embD: null,
    eimM: '',
    eimD: null,

    esmM: null,
    esmD: null,

    hasAirVoid: false,

    balL: 0, // dlugosc balkonow

    /**
     * Step 5 - Okna i drzwi
     */

    uW: '',
    uD: '',

    aWN: null,
    aWE: null,
    aWS: null,
    aWW: null,

    ad: null,

    yearOfWindows: null,

    /**
     * Step 6 - Dach
     */

    lDrywall: '',
    lMaterial: null,
    roofAreaFactor: '',

    wA: null,
    wB: null,
    hK: null,

    rimM: null,
    rimD: null,
    kwh: null,

    hasInsulation: false,

    /**
     * Step 7 - Poddasze
     */

    isAtticHeated: false,

    asbmM: '',
    asbmD: null,
    asimM: '',
    asimD: null,

    assmM: null,
    assmD: null,

    roofInsulationType: null,

    /**
     * Step 8 - Piwnica
     */

    bsbmM: '',
    bsbmD: null,
    bsimM: '',
    bsimD: null,

    gsimM2: '',
    gsimD2: null,
    ebbmM: '',
    ebbmD: null,

    ebimM: '',
    ebimD: null,
    fhb: null,
    z: null,

    gsbmM2: null,
    gsbmD2: null,

    /**
     * Pozostałe
     */

    name: '',

    // fhR: null, // - fh + 30cm czyli to na backend

    // Ściana piwnicy

    // uR - Nie zostalo podane lub uzyte w podalszych obliczeniach

    // Okna i drzwi

    uTBEW: null,
    uTBS: null,
    uTBWD: null,

    //aD = 2.1 * 0.8;

    //Wentylacjar

    qINT: null, // - Zyski wewnetrzne, wartosci z tabeli w zaleznosci od rodzaju budynky
};

export const steps = ref([
    {
        icon: 'pi pi-building',
        name: 'Typ Zabudowy',
    },
    {
        icon: 'ph ph-barn',
        name: 'Lokalizacja',
    },
    {
        icon: 'pi pi-home',
        name: 'Ogólne',
    },
    {
        icon: 'pi pi-stop',
        name: 'Ściany',
    },
    {
        icon: 'pi pi-table',
        name: 'Okna i drzwi',
    },
    {
        icon: 'pi pi-calendar',
        name: 'Dach',
    },
    {
        icon: 'pi pi-calendar',
        name: 'Poddasze',
    },
    {
        icon: 'pi pi-check',
        name: 'Piwnica',
    },
]);

export const formName = 'calculation-form';

export const formService = new StepByStepService(formName);

export const initForm = () => formService.initForm<CalculationForm>(calculationForm);
