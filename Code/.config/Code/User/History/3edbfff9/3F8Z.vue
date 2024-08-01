<script setup lang="ts">
import { CalculationForm, initForm } from '@/Pages/Calculation/Partials/config';
import Create from '@/Pages/Calculation/Create.vue';
import CalculationHorizontalInput from '@/Components/Calculation/CalculationHorizontalInput.vue';
import CalculationCheckbox from '@/Components/Calculation/CalculationCheckbox.vue';
import InputGroup from 'primevue/inputgroup';
import { useForm, usePage } from '@inertiajs/vue3';
import { computed, ref, shallowRef } from 'vue';
import { PageProps } from '@/types';
import { getValuesFromProps } from '@/utils/getValuesFromProps';
import { EnumOptionsResource } from '@/Resources/EnumOptions.resource';
import CalculationAutoComplete from '@/Components/Calculation/CalculationAutoComplete.vue';
import { MaterialResource } from '@/Resources/Material.resource';
import WallDimensionPreview from '../WallDimensionPreview.vue';

const { readonly, draftForm } = defineProps<{
    readonly?: boolean;
    draftForm?: CalculationForm;
}>();
const parentComponent = shallowRef(readonly ? 'div' : Create);

const form = draftForm ? useForm(draftForm) : initForm();

const baCalculate = () => {
    if (form.bl && form.bl > 0 && form.bw && form.bw > 0) {
        form.ba = form.bl * form.bw;
    } else {
        form.ba = null;
    }
};

const bpCalculate = () => {
    if (form.bl && form.bl > 0 && form.bw && form.bw > 0) {
        form.bp = 2 * (form.bl + form.bw);
    } else {
        form.bp = null;
    }
};

const { substrateTypeList } = getValuesFromProps<{ substrateTypeList: Array<EnumOptionsResource> }>();

const materials = usePage<PageProps<{ materials: Array<MaterialResource> }>>().props.materials;

const { yearOfConstructionOptions, typesOfVentilationOptions } = getValuesFromProps<{
    yearOfConstructionOptions: Array<EnumOptionsResource>;
    typesOfVentilationOptions: Array<EnumOptionsResource>;
}>();
</script>

<template>
    <component :is="parentComponent" v-model:form="form">
        <div class="card">
            <div class="grid">
                <div class="col-12">
                    <div class="text-900 font-medium text-xl mb-3">Ogólne</div>
                    <p class="m-0 p-0 text-600 line-height-3 mr-3">Tutaj będą opisy poszczególnych sekcji</p>
                </div>

                <div class="col-12">
                    <Fieldset class="h-full">
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Zabudowa</span>
                            </div>
                        </template>

                        <CalculationHorizontalInput
                            label="Rok zabudowy"
                            :error-message="form.errors.yearOfConstruction"
                        >
                            <template #input>
                                <Dropdown
                                    v-model="form.yearOfConstruction"
                                    :options="yearOfConstructionOptions"
                                    optionLabel="label"
                                    placeholder="Rok zabudowy"
                                    class="w-full"
                                    :disabled="readonly"
                                    id="yearOfConstruction"
                                />
                            </template>
                        </CalculationHorizontalInput>

                        <CalculationHorizontalInput
                            label="Rodzaj wentylacji"
                            :error-message="form.errors.typeOfVentilation"
                        >
                            <template #input>
                                <Dropdown
                                    v-model="form.typeOfVentilation"
                                    :options="typesOfVentilationOptions"
                                    optionLabel="label"
                                    placeholder="Rodzaj wentylacji"
                                    class="w-full"
                                    :disabled="readonly"
                                    id="typeOfVentilation"
                                />
                            </template>
                        </CalculationHorizontalInput>

                        <CalculationHorizontalInput
                            class="field mb-2"
                            v-model="form.totalInhabitants"
                            label="Liczba osób mieszkających"
                            :error-message="form.errors.totalInhabitants"
                            :disabled="readonly"
                            :readonly="readonly"
                        >
                            <template #after>
                                <div
                                    class="hidden w-full align-self-center md:inline-flex align-items-center flex-row gap-2"
                                >
                                    <img
                                        v-for="_ in Math.min(5, form.totalInhabitants)"
                                        src="/images/Liczba osób mieszkających.jpg"
                                        alt=""
                                        height="40"
                                    />
                                    <i v-if="form.totalInhabitants > 5" class="ph ph-plus" />
                                </div>
                            </template>
                        </CalculationHorizontalInput>
                    </Fieldset>
                </div>

                <div class="col-12">
                    <Fieldset class="h-full">
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Wymiary</span>
                            </div>
                        </template>

                        <CalculationHorizontalInput
                            v-model="form.bl"
                            label="Długość zabudowy [m]"
                            :error-message="form.errors.bl"
                            :disabled="readonly"
                            :readonly="readonly"
                        >
                            <template #after>
                                <div class="relative w-full">
                                    <WallDimensionPreview
                                        class="hidden lg:flex absolute left-50"
                                        style="top: 2rem; transform: translateX(-50%)"
                                        :width="form.bw ?? 1"
                                        :height="form.bl ?? 1"
                                    />
                                </div>
                            </template>
                        </CalculationHorizontalInput>

                        <CalculationHorizontalInput
                            v-model="form.bw"
                            label="Szerokość zabudowy [m]"
                            :error-message="form.errors.bw"
                            :disabled="readonly"
                            :readonly="readonly"
                        />

                        <CalculationHorizontalInput
                            v-model="form.bp"
                            label="Obwód zabudowy [m]"
                            :error-message="form.errors.bp"
                            :disabled="readonly"
                            :readonly="readonly"
                        >
                            <template #input-group>
                                <Button label="Oblicz" :disabled="readonly" @click="bpCalculate" />
                            </template>
                        </CalculationHorizontalInput>

                        <CalculationHorizontalInput
                            v-model="form.ba"
                            label="Powierzchnia zabudowy [m²]"
                            :error-message="form.errors.ba"
                            :disabled="readonly"
                            :readonly="readonly"
                        >
                            <template #input-group>
                                <Button label="Oblicz" :disabled="readonly" @click="baCalculate" />
                            </template>
                        </CalculationHorizontalInput>
                    </Fieldset>
                </div>

                <div class="col-12">
                    <Fieldset>
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Kondygnacje</span>
                            </div>
                        </template>

                        <CalculationHorizontalInput
                            v-model="form.fhn"
                            label="Liczba kondygnacji ogrzewanych"
                            :error-message="form.errors.fhn"
                            :disabled="readonly"
                            :readonly="readonly"
                        />

                        <CalculationHorizontalInput
                            v-model="form.fh"
                            label="Wysokość kondygnacji [m] (+30cm)"
                            :error-message="form.errors.fh"
                            :disabled="readonly"
                            :readonly="readonly"
                        />

                        <CalculationHorizontalInput
                            v-model="form.eiTemp"
                            label="Oczekiwana temperatura wewnetrzna"
                            :error-message="form.errors.eiTemp"
                            :disabled="readonly"
                            :readonly="readonly"
                        />

                        <CalculationHorizontalInput
                            label="Typ podłoża"
                            :error-message="form.errors.substrateType"
                            :disabled="readonly"
                            :readonly="readonly"
                        >
                            <template #input>
                                <Dropdown
                                    v-model="form.substrateType"
                                    :options="substrateTypeList"
                                    optionLabel="label"
                                    placeholder="Typ podłoża"
                                    class="w-full"
                                    :disabled="readonly"
                                />
                            </template>
                        </CalculationHorizontalInput>

                        <!-- TODO: to mi się nie podoba UIowo-->

                        <CalculationCheckbox
                            class="ml-3"
                            v-model="form.hasBasement"
                            label="Czy dom ma piwnicę?"
                            :readonly="readonly"
                            :disabled="readonly"
                            @update:model-value="() => (form.isBasementHeated = false)"
                        />

                        <CalculationCheckbox
                            class="ml-3"
                            v-model="form.hasAttic"
                            label="Czy dom ma poddasze?"
                            :readonly="readonly"
                            :disabled="readonly"
                        />
                    </Fieldset>
                </div>

                <div v-if="!form.hasBasement" class="col-12">
                    <!---
                        Te pola od powierzchni podlogi maja sie tu wyswietlac jesli nie mamy piwnicy.
                        Jesli mamy piwnice to sa w kroku z piwnica
                    -->
                    <Fieldset>
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Materiał podstawowy</span>
                            </div>
                        </template>

                        <CalculationHorizontalInput
                            label="Materiał podłogi"
                            :error-message="form.errors.gsimM"
                            :disabled="readonly"
                            :readonly="readonly"
                        >
                            <template #input>
                                <CalculationAutoComplete
                                    v-model="form.gsimM"
                                    label="Materiał podłogi"
                                    :error-message="form.errors.gsimM"
                                    :items="materials"
                                    :disabled="readonly"
                                />
                            </template>
                            <template #after>
                                <CalculationHorizontalInput
                                    class="field"
                                    v-model="form.gsimD"
                                    label="Grubość podłogi [m]"
                                    :error-message="form.errors.gsimD"
                                    :disabled="readonly"
                                    :readonly="readonly"
                                />
                                <InputNumber
                                    v-model="form.gsimD"
                                    id="gsimD"
                                    type="text"
                                    :minFractionDigits="0"
                                    :maxFractionDigits="8"
                                    :class="{ 'p-invalid': form.errors.gsimD }"
                                    :readonly="readonly"
                                    :disabled="readonly"
                                />
                            </template>
                        </CalculationHorizontalInput>

                        <div class="grid formgrid p-fluid align-items-start">
                            <CalculationHorizontalInput
                                class="field"
                                v-model="form.gsimD"
                                label="Grubość podłogi [m]"
                                :error-message="form.errors.gsimD"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </div>
                    </Fieldset>

                    <Fieldset class="mt-5">
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Materiał izolacyjny</span>
                            </div>
                        </template>

                        <div class="grid formgrid p-fluid align-items-start">
                            <CalculationAutoComplete
                                v-model="form.gsbmM"
                                label="Materiał izolacyjny podłogi"
                                :error-message="form.errors.gsbmM"
                                :items="materials"
                                :disabled="readonly"
                            />
                            <CalculationHorizontalInput
                                class="field"
                                v-model="form.gsbmD"
                                label="Grubość izolacyjny podłogi [m]"
                                :error-message="form.errors.gsbmD"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </div>
                    </Fieldset>
                </div>
            </div>
        </div>
    </component>
</template>
