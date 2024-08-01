<?php

namespace App\Enums;

use App\Enums\Attributes\Description;
use App\Enums\Attributes\GetsAttributes;
use App\Enums\Methods\ValuesToList;

enum TypesOfVentilation: string
{
    use GetsAttributes, ValuesToList;

    #[Description('Mechaniczna')]
    case MECHANICAL = 'MECHANICAL';

    #[Description('Grawitacyjna')]
    case GRAVITATIONAL = 'GRAVITATIONAL';
}
