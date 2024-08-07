<script setup lang="ts">
import { CalculationForm, initForm } from '@/Pages/Calculation/Partials/config';
import Create from '@/Pages/Calculation/Create.vue';
import CalculationInput from '@/Components/Calculation/CalculationInput.vue';
import CalculationAutoComplete from '@/Components/Calculation/CalculationAutoComplete.vue';
import CalculationCheckbox from '@/Components/Calculation/CalculationCheckbox.vue';
import { useForm, usePage } from '@inertiajs/vue3';
import { PageProps } from '@/types';
import { IsolatorResource } from '@/Resources/Isolator.resource';
import { MaterialResource } from '@/Resources/Material.resource';
import { ref, shallowRef } from 'vue';
import CalculationHorizontalAutoComplete from '@/Components/Calculation/CalculationHorizontalAutoComplete.vue';

const { readonly, draftForm } = defineProps<{
    readonly?: boolean;
    draftForm?: CalculationForm;
}>();
const parentComponent = shallowRef(readonly ? 'div' : Create);

const form = draftForm ? useForm(draftForm) : initForm();

const isolators = usePage<PageProps<{ isolators: Array<IsolatorResource> }>>().props.isolators;
const materials = usePage<PageProps<{ materials: Array<MaterialResource> }>>().props.materials;

const roofTypes = [
    { name: 'Płaski', value: 1.2 },
    { name: 'Jednospadowy', value: 1.44 },
    { name: 'Dwuspadowy', value: 1.44 },
    { name: 'Czterospadowy', value: 1.72 },
];
</script>

<template>
    <component :is="parentComponent" v-model:form="form">
        <div class="card">
            <div class="grid">
                <div class="col-12 lg:col-2">
                    <div class="text-900 font-medium text-xl mb-3">Dach</div>
                    <p class="m-0 p-0 text-600 line-height-3 mr-3">Tutaj będą opisy poszczególnych sekcji</p>
                </div>

                <div class="col-12">
                    <Fieldset>
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Rodzaj dachu</span>
                            </div>
                        </template>

                        <CalculationHorizontalAutoComplete
                            v-model="form.roofAreaFactor"
                            label="Rodzaj dachu"
                            :error-message="form.errors.roofAreaFactor"
                            :items="roofTypes"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                    </Fieldset>
                </div>

                <div class="col-12">
                    <Fieldset>
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Rodzaj dachu</span>
                            </div>
                        </template>

                        <CalculationHorizontalAutoComplete
                            v-model="form.roofAreaFactor"
                            label="Rodzaj dachu"
                            :error-message="form.errors.roofAreaFactor"
                            :items="roofTypes"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                    </Fieldset>
                </div>

                <div>
                    <div class="grid formgrid p-fluid align-items-start">
                        <!--                        <CalculationAutoComplete-->
                        <!--                            v-model="form.lDrywall"-->
                        <!--                            label="Izolacja między krokwiami"-->
                        <!--                            :col="4"-->
                        <!--                            :error-message="form.errors.lDrywall"-->
                        <!--                            :items="isolators"-->
                        <!--                            :disabled="readonly"-->
                        <!--                        />-->
                        <!--                        <CalculationInput-->
                        <!--                            v-model="form.lMaterial"-->
                        <!--                            label="Grubość izolacji między krokwiami"-->
                        <!--                            :col="4"-->
                        <!--                            :error-message="form.errors.lMaterial"-->
                        <!--                            :disabled="readonly"-->
                        <!--                            :readonly="readonly"-->
                        <!--                        />-->
                    </div>
                    <div class="grid formgrid p-fluid align-items-start">
                        <!--                        <CalculationInput-->
                        <!--                            v-model="form.wA"-->
                        <!--                            label="Grubość krokwi [m]"-->
                        <!--                            :col="4"-->
                        <!--                            :error-message="form.errors.wA"-->
                        <!--                            :disabled="readonly"-->
                        <!--                            :readonly="readonly"-->
                        <!--                        />-->
                        <!--                        <CalculationInput-->
                        <!--                            v-model="form.wB"-->
                        <!--                            label="Rozstaw krokwi [m]"-->
                        <!--                            :col="4"-->
                        <!--                            :error-message="form.errors.wB"-->
                        <!--                            :disabled="readonly"-->
                        <!--                            :readonly="readonly"-->
                        <!--                        />-->
                        <!--                        <CalculationInput-->
                        <!--                            v-model="form.hK"-->
                        <!--                            label="Wysokość krokwi [m]"-->
                        <!--                            :col="4"-->
                        <!--                            :error-message="form.errors.hK"-->
                        <!--                            :disabled="readonly"-->
                        <!--                            :readonly="readonly"-->
                        <!--                        />-->
                    </div>
                    <div class="grid formgrid p-fluid align-items-start">
                        <CalculationAutoComplete
                            v-model="form.rimM"
                            label="Materiał izolacji dachu"
                            :col="4"
                            :error-message="form.errors.rimM"
                            :items="materials"
                            :disabled="readonly"
                        />
                        <CalculationInput
                            v-model="form.rimD"
                            label="Grubość izolacji dachu [m]"
                            :col="4"
                            :error-message="form.errors.rimD"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                        <CalculationInput
                            v-model="form.kwh"
                            label="Wysokość ściany kolankowej [m]"
                            :col="4"
                            :error-message="form.errors.kwh"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                    </div>
                    <!--                    <div class="grid formgrid p-fluid align-items-start">-->
                    <!--                        <CalculationCheckbox-->
                    <!--                            v-model="form.hasInsulation"-->
                    <!--                            :col="4"-->
                    <!--                            label="Czy dach ma docieplenie?"-->
                    <!--                            :disabled="readonly"-->
                    <!--                            :readonly="readonly"-->
                    <!--                        />-->
                    <!--                    </div>-->
                </div>
            </div>
        </div>
    </component>
</template>
