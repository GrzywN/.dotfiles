<?php

namespace App\Http\Controllers\Web;

use App\Enums\PropertyType;
use App\Enums\RoofInsulationType;
use App\Enums\SubstrateType;
use App\Enums\TypesOfVentilation;
use App\Enums\YearOfConstruction;
use App\Http\Requests\CalculatorFactorsRequest;
use App\Models\Calculation;
use App\Models\Door;
use App\Models\Isolator;
use App\Models\Material;
use App\Models\Window;
use App\Services\CalculationService;
use App\Services\DoorService;
use App\Services\IsolatorService;
use App\Services\MaterialService;
use App\Services\WindowService;
use Exception;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class CalculationController
{
    public function __construct(
        protected CalculationService $calculationService,
        protected DoorService $doorService,
        protected WindowService $windowService,
        protected MaterialService $materialService,
        protected IsolatorService $isolatorService,
    ) {

    }

    /**
     * @throws Exception
     */
    public function index(): Response
    {
        return Inertia::render('Calculation/Index', [
            'calculations' => $this->calculationService->index(),
        ]);
    }

    public function show(Calculation $calculation): Response
    {
        return Inertia::render('Calculation/Show', [
            'calculation' => $this->calculationService->show($calculation),

            'doors' => Door::all(),
            'windows' => Window::all(),
            'materials' => Material::all(),
            'isolators' => Isolator::all(),

            'propertyTypeList' => PropertyType::toOptionsList(),

            'substrateTypeList' => SubstrateType::toOptionsList(),

            'debugData' => request()->session()->pull('calculation-debug'),

        ]);
    }

    /**
     * @throws Exception
     */
    public function create(
    ): Response {
        $step = CalculatorFactorsRequest::getCurrentStep();

        dump($step);

        return Inertia::render("Calculation/Partials/Steps/Step$step", [
            'step' => $step,

            'doors' => Door::all(),
            'windows' => Window::all(),
            'materials' => Material::all(),
            'isolators' => Isolator::all(),

            'propertyTypeList' => PropertyType::toOptionsList(),

            'substrateTypeList' => SubstrateType::toOptionsList(),

            'yearOfConstructionOptions' => YearOfConstruction::toOptionsList(),
            'typesOfVentilationOptions' => TypesOfVentilation::toOptionsList(),

            'roofInsulationTypeList' => RoofInsulationType::toOptionsList(),

        ]);
    }

    public function store(
        CalculatorFactorsRequest $request
    ) {
        if (! auth()->user()->activeOZCLimit()->exists()) {
            return back()->withErrors([
                'limitMessage' => 'Twój pakiet wyczerpał limit, lub stracił ważność!',
            ]);
        }

        $calculation = $this->calculationService->store($request);

        if ($calculation) {
            return to_route('calculations.show', $calculation);
        }
    }

    public function exportToExcel(Request $request)
    {
        $path = $this->calculationService->exportToExcel($request->input('calculationIds'));

        return Inertia::location($path);
    }

    public function saveDraft(Request $request)
    {
        $this->calculationService->saveDraft($request->input('draft'));
    }
}
